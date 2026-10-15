extends Node2D
class_name World

signal splayed_card_clicked(card:CardDisplay)
signal lane_clicked(lane:Lane)

# Simple layer for connecting signals across the scene tree

@onready var lanes = $Lanes
@onready var card_display: = $CanvasLayer/CenterContainer/HBoxContainer
static var instance:World #im going to essentially treat World class as a singleton
var lane_list:Array[Lane] = []
var current_list:Array
var card_draw_sound = null
@export var viewport_effects:ViewportEffects
#@onready var hand: Hand = $Hand

func _ready():
	instance = self
	card_draw_sound = FmodServer.create_event_instance("event:/Card Deal")
	lane_list.push_front(lanes.get_node("Lane"))
	lane_list.push_front(lanes.get_node("Lane2"))
	lane_list.push_front(lanes.get_node("Lane3"))
	RM.reset()
	for lane in lane_list:
		var draw_pile = lane.get_node("Draw Pile")
		var discard_pile = lane.get_node("Discard Pile")
		
		draw_pile.deck_clicked.connect(splay)
		discard_pile.deck_clicked.connect(splay)

# Display contents of a pile of cards at center of screen
# Ignore if there are 0 cards in pile
func splay(cards: Array):
	var typed_list:Array[CardData]
	for c in cards:
		typed_list.append(c)
	# clear current cards in card display
	for child in card_display.get_children():
		child.queue_free()
	
	# add new cards to card display
	current_list = cards
	for data in cards:
		var card = CardDisplay.create_from_data(data)
		card.mouse_filter = Control.MouseFilter.MOUSE_FILTER_STOP
		card.draggable = false
		card.clicked.connect(on_card_clicked)
		card_display.add_child(card)
		#card.display()
		card_draw_sound.start()
		card_draw_sound.release()

	
	if current_list.size() > 0:
		$CanvasLayer/CenterContainer.display()
	else:
		$CanvasLayer/CenterContainer.disappear()

func get_all_cards_in_play() -> Array[CardData]:
	var combined_array:Array
	for l in lane_list:
		combined_array.append_array(l.get_combined_card_list())
	return combined_array

func on_card_clicked(card:CardDisplay):
	splayed_card_clicked.emit(card)
	#update display if call does something
	for l in lane_list:
		l._update_pile_counts() #we out here calling 'private' methods from outside the class
	
	splay.call_deferred(current_list)
	#splay(current_list) #redisplay list

func request_lane_card_selection(ve_type:ViewportEffects.types):
	
	viewport_effects.apply_type(ve_type)
	for l in lane_list:
		l.request_card_selection()
		
func request_lane_selection(ve_type:ViewportEffects.types = viewport_effects.types.BUFF):
	
	viewport_effects.apply_type(ve_type)
	for l in lane_list:
		l.clicked.connect(lane_clicked.emit)
		l.selection_requested = true
		l.midlight()

func end_lane_selection():
	viewport_effects.cancel()
	var node_sound = FmodServer.create_event_instance("event:/Node Select")
	node_sound.start()
	node_sound.release()
	for l in lane_list:
		l.clicked.disconnect(lane_clicked.emit)
		l.selection_requested = false
		l.dehighlight()

func cancel_selection(ve_type:ViewportEffects.types):
	viewport_effects.cancel(ve_type)
	splay([])
	for l in lane_list:
		l.pile_highlight_reset()


#DEBUG FORCE FAVOR
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("1"):
		@warning_ignore("int_as_enum_without_cast")
		RM.score_favor(0,25)
	if event.is_action_pressed("2"):
		@warning_ignore("int_as_enum_without_cast")
		RM.score_favor(1,25)
	if event.is_action_pressed("3"):
		@warning_ignore("int_as_enum_without_cast")
		RM.score_favor(2,25)
