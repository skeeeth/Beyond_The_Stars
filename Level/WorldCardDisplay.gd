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
@export var viewport_effects:ViewportEffects

func _ready():
	instance = self
	
	lane_list.push_front(lanes.get_node("Lane"))
	lane_list.push_front(lanes.get_node("Lane2"))
	lane_list.push_front(lanes.get_node("Lane3"))
	
	for lane in lane_list:
		var draw_pile = lane.get_node("Draw Pile")
		var discard_pile = lane.get_node("Discard Pile")
		
		draw_pile.deck_clicked.connect(splay)
		discard_pile.deck_clicked.connect(splay)

# Display contents of a pile of cards at center of screen
# Ignore if there are 0 cards in pile
func splay(cards: Array):
	# clear current cards in card display
	for child in card_display.get_children():
		child.queue_free()
	
	# add new cards to card display
	current_list = cards
	for card in cards:
		card = CardDisplay.create_from_data(card)
		card.mouse_filter = Control.MOUSE_FILTER_STOP
		card.clicked.connect(on_card_clicked)
		card_display.add_child(card)
		var card_draw_sound = FmodServer.create_event_instance("event:/Card Deal")
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
		
func request_lane_selection():
	for l in lane_list:
		l.clicked.connect(lane_clicked.emit)
		l.selection_requested = true
		l.midlight()

func end_lane_selection():
	for l in lane_list:
		l.clicked.disconnect(lane_clicked.emit)
		l.selection_requested = false
		l.dehighlight()

func cancel_selection(ve_type:ViewportEffects.types):
	viewport_effects.cancel(ve_type)
	splay([])
	for l in lane_list:
		l.pile_highlight_reset()
