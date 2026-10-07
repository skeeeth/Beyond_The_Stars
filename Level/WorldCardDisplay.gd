extends Node2D
class_name World

signal splayed_card_clicked(card:CardDisplay)

# Simple layer for connecting signals across the scene tree

@onready var lanes = $Lanes
@onready var card_display = $CanvasLayer/CenterContainer/HBoxContainer
static var instance:World #im going to essentially treat World class as a singleton
var lane_list:Array[Lane] = []
var current_list:Array

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
	
	$CanvasLayer/CenterContainer.display()



func on_card_clicked(card:CardDisplay):
	splayed_card_clicked.emit(card)
	
	#update display if call does something
	for l in lane_list:
		l._update_pile_counts() #we out here calling 'private' methods from outside the class
	
	splay.call_deferred(current_list)
	#splay(current_list) #redisplay list

func request_lane_card_selection():
	pass
