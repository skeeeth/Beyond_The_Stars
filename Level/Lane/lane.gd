extends Control
class_name Lane


signal clicked(who:Lane)
signal card_added(card:CardData)
signal lane_scored(who:Lane)
signal scoring_started


@export var type:RM.types

@export var deck:Array[CardData]
var discard:Array[CardData]

var active_cards:Array[CardDisplay]
var cards_queued_for_removal:Array[CardDisplay]
var x_spacing = 2

var card_plays:int = 0:
	set(v):
		card_plays = v
		#%"Play Button".text = "Play %s Cards" % card_plays
	get:
		return card_plays

#var score_sound

#var draw_pile:Pile
#var discard_pile:Pile
@onready var draw_pile: Pile = %"Draw Pile"
@onready var discard_pile: Pile = %"Discard Pile"
@onready var god_position: Node2D = $GodPosition
@onready var click_hitbox: Panel = $"Click Hitbox"
@onready var camera_position: Node2D = $"Camera position"
@onready var card_start_position: Node2D = $"Card Start Position"

#@onready var resource_map: ResourceMap = $"Resource Map"

#@onready var highlighter: Highlighter = $Highlighter

@onready var buttons:Array[Button] = [%"Play Button", $Upgrade]
@export var lane_strategies:Array[BaseCardStrategy]

var god_strategies:Array[BaseCardStrategy]

static var strategy_pause:float = 0.5
var button_supressions:int = 1

var selection_requested:bool = false

func _ready() -> void:
	draw_pile.array = deck
	discard_pile.array = discard
	card_plays = card_plays #runs setter function
	_update_pile_counts()

func _update_pile_counts():
	draw_pile.update()
	discard_pile.update()

func draw_card():
	if deck.size() == 0:
		if discard.size() == 0:
			draw_fail()
			return
		#reshuffle
		for c in discard: 
			deck.append(c)
		deck.shuffle()
		discard.clear()
	#discard.push_back(res)
	
	#Play card deal audio
	var card_deal_sound = FmodServer.create_event_instance("event:/Card Deal")
	card_deal_sound.start()
	card_deal_sound.release()
	
	var res = deck.pop_front()
	var new_card = CardDisplay.create_from_data(res)
	add_child(new_card)
	new_card.position = draw_pile.position
	active_cards.append(new_card)
	new_card.removal_requested.connect(cards_queued_for_removal.append)
	
	var draw_slide = create_tween()
	var destination = card_start_position.position
	destination += Vector2((active_cards.size()-1)  * (CardDisplay.card_size.x + x_spacing),0)
	#destination.x += x_spacing
	draw_slide.tween_property(new_card,"position",destination,0.2).set_ease(Tween.EASE_OUT)
	#new_card.score(type)
	
	_update_pile_counts()

#like if girl failure was a card draw
func draw_fail():
	var wiggle = self.create_tween()
	var start:float = draw_pile.position.x
	var wiggle_amount = 15
	for i in range(0,5):
		wiggle.tween_property(draw_pile,"position:x",start + wiggle_amount,0.05)
		wiggle_amount *= -0.8
	
	wiggle.tween_property(draw_pile,"position:x",start,0.05)
	var draw_fail_sound = FmodServer.create_event_instance("event:/Card Waterfall")
	draw_fail_sound.start()
	draw_fail_sound.release()

func _on_button_pressed() -> void:
	play()
	var UI_confirm_sound = FmodServer.create_event_instance("event:/UI Confirm")
	UI_confirm_sound.start()
	UI_confirm_sound.release()

func add_card(data:CardData):
	card_added.emit(data)
	deck.append(data)
	deck.shuffle()
	_update_pile_counts()

func play():
	scoring_started.emit()
	disable_buttons()
	#play out cards from hand
	var play_tween = create_tween()
	for i in range(0,card_plays):
		play_tween.tween_callback(draw_card)
		play_tween.tween_interval(0.35)
	
	#play_tween.tween_interval(2) #leave cards visible for a delay
	await play_tween.finished
	
#region During Play
	var strategy_tween = create_tween()
	for c in active_cards:
		var starting_y = c.position.y
		strategy_tween.tween_property(c,"position:y", starting_y - 20, 0.05)
		
		#play scoring sound on animiation
		var play_score_sound = func pss(): #full call as lambda
			var score_sound = FmodServer.create_event_instance("event:/Bell")
			score_sound.start()
			score_sound.release()
		strategy_tween.tween_callback(play_score_sound)
		
		var apply_strategy_stack = func(strategies:Array[BaseCardStrategy]):
			for s in strategies:
				strategy_tween.tween_callback(s.apply.bind(c.data,self,active_cards))
				strategy_tween.tween_callback(c.display)
				strategy_tween.tween_interval(strategy_pause)
		
		apply_strategy_stack.call(lane_strategies)
		apply_strategy_stack.call(god_strategies)
		apply_strategy_stack.call(c.data.get_keyword_strategies())

		strategy_tween.tween_property(c,"position:y", starting_y, 0.05)
		strategy_tween.tween_interval(0.1)
	
	#quick pause between strategies finished and scoring
	strategy_tween.tween_interval(0.4)
	#score after all strategies
	for c in active_cards:
		strategy_tween.tween_callback(c.score.bind(type))
		strategy_tween.tween_callback(c.display)
		strategy_tween.tween_interval(0.1)
	
	strategy_tween.tween_interval(0.4)
	await strategy_tween.finished
#endregion
	
	#send all cards to discard at once
	var discard_tween = create_tween()
	discard_tween.set_parallel(true)
	for card in cards_queued_for_removal:
		active_cards.erase(card)
		discard.erase(card.data)
		deck.erase(card.data)
		discard_tween.tween_interval(0.5)
		card.be_eaten()
	
	cards_queued_for_removal.clear()
	
	for c in active_cards:
		discard_tween.tween_callback(c.data.reset_temp_values)
		discard_tween.tween_callback(c.display)
		discard_tween.tween_callback(discard.append.bind(c.data))
		discard_tween.tween_property(c,"position",discard_pile.position,0.2)
	for c in active_cards:
		discard_tween.chain().tween_callback(c.queue_free)
	
	discard_tween.tween_callback(_update_pile_counts)
	
	discard_tween.tween_interval(0.1)
	discard_tween.tween_callback(lane_scored.emit.bind(self))
	
	active_cards.clear()
	enable_buttons()

func gain_upgrade():
	card_plays += 1

func disable_buttons():
	button_supressions += 1
	if button_supressions > 0:
		for b in buttons:
			if b:
				b.disabled = true

func enable_buttons():
	button_supressions -= 1
	print("Enabled buttons; button supressions: %s" % button_supressions)
	if button_supressions == 0:
		for b in buttons:
			if b:
				b.disabled = false
			
func get_combined_card_list() -> Array[CardData]:
	var combined_array:Array[CardData]
	for c in deck:
		combined_array.append(c)
	
	for c in discard:
		combined_array.append(c)
	
	return combined_array

func highlight():
	click_hitbox.modulate = Color.WHITE
	#highlighter.enable()

func dehighlight():
	click_hitbox.modulate = Color(Color.WHITE,0)
	#highlighter.disable()

func midlight():
	click_hitbox.modulate = Color.GRAY

func request_card_selection():
	draw_pile.set_highlight_mode(Pile.highlight_modes.PULSING)
	discard_pile.set_highlight_mode(Pile.highlight_modes.PULSING)
	
func pile_highlight_reset():
	draw_pile.set_highlight_mode(Pile.highlight_modes.OFF)
	discard_pile.set_highlight_mode(Pile.highlight_modes.OFF)

##used to validate click and drag data, for now thats only cards so this could honestly just return literal true
func _can_drop_data(_position, data):
	var result = typeof(data) == TYPE_DICTIONARY and data.has("RES")
	if result: highlight()
	return result

##called on mouse release when dragging suitable data, in this case meaning a card was dragged from hand
func _drop_data(at_position: Vector2, data: Variant) -> void:
	var card_data:CardData = data["RES"]
	
	if !RM.try_spend_all(card_data.resource_costs):
		return
	
	var dummy_display = CardDisplay.create_from_data(card_data)
	draw_pile.fly_in_card(dummy_display)
	add_child(dummy_display)
	dummy_display.position = at_position
	
	click_hitbox.modulate = Color(Color.WHITE,0)
	
	#RM.try_spend(RM.types.BLUE, 1)
	add_card(card_data)
	data["source"].queue_free()



func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("LMB"):
		clicked.emit(self)
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	if selection_requested:
		midlight()
	else:
		dehighlight()

func _on_mouse_entered() -> void:
	if selection_requested:
		var lane_hover = FmodServer.create_event_instance("event:/UI Hover")
		lane_hover.start()
		lane_hover.release()
		highlight()
