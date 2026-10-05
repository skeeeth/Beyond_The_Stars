extends Control
class_name Lane

@export var type:RM.types

@export var deck:Array[CardData]
var discard:Array[CardData]

var active_cards:Array[CardDisplay]
var x_spacing = 25

var card_plays:int = 2:
	set(v):
		card_plays = v
		%"Play Button".text = "Play %s Cards" % card_plays
	get:
		return card_plays

#var draw_pile:Pile
#var discard_pile:Pile
@onready var draw_pile: Pile = %"Draw Pile"
@onready var discard_pile: Pile = %"Discard Pile"
@onready var god_position: Node2D = $GodPosition


func _ready() -> void:
	draw_pile.array = deck
	discard_pile.array = discard
	card_plays = card_plays #runs setter function
	_update_pile_counts()

func _update_pile_counts():
	draw_pile.update()
	discard_pile.update()

func draw_card():
	var res = deck.pop_front()
	discard.push_back(res)
	
	var new_card = CardDisplay.create_from_data(res)
	add_child(new_card)
	active_cards.append(new_card)
	var draw_slide = create_tween()
	var destination = Vector2(active_cards.size() * (CardDisplay.card_size.x + x_spacing),0)
	draw_slide.tween_property(new_card,"position",destination,0.2).set_ease(Tween.EASE_OUT)
	new_card.score(type)
	
	#reshuffle
	if deck.size() == 0:
		#deck = discard.duplicate()
		for c in discard: 
			deck.append(c)
		deck.shuffle()
		discard.clear()
	
	_update_pile_counts()


func _on_button_pressed() -> void:
	play()
	pass # Replace with function body.

func play():
	var play_tween = create_tween()
	for i in range(0,card_plays):
		play_tween.tween_callback(draw_card).set_delay(0.3)
	
	play_tween.tween_interval(2)
	await play_tween.finished
	var discard_tween = create_tween()
	discard_tween.set_parallel(true)
	for c in active_cards:
		discard_tween.tween_property(c,"position",discard_pile.position,0.3)
	for c in active_cards:
		discard_tween.chain().tween_callback(c.queue_free)
	active_cards.clear()
	

func gain_upgrade():
	card_plays += 1

##used to validate click and drag data, for now thats only cards so this could honestly just return literal true
func _can_drop_data(_position, data):
	return typeof(data) == TYPE_DICTIONARY and data.has("RES")

##called on mouse release when dragging suitable data, in this case meaning a card was dragged from hand
func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var card_data:CardData = data["RES"]
	
	if !RM.try_spend_all(card_data.resource_costs):
		return
	
	deck.append(data["RES"])
	deck.shuffle()
	data["source"].queue_free()
	_update_pile_counts()
