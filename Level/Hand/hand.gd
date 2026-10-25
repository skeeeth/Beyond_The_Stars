extends Node2D
class_name Hand

signal card_grabbed
signal card_released

static var card_pool:Array[CardData]
@export var starting_pool:Array[CardData]
@export var container:Container
@export var starting_cards:int = 3
@export var max_hand_size:int = 8
#@onready var hand_label: Label = $"Hand Label"
var cards_in_hand:int = 0:
	set(v):
		cards_in_hand = v
		%"Hand Label".text = "Hand (%s/%s)" % [cards_in_hand,max_hand_size]

var draw_cost:int = 1:
	set(v):
		draw_cost = v
		%"Cost Text".text = ":%s " % draw_cost
	get:
		return draw_cost
@onready var button: Button = $Button

func _ready() -> void:
	#RM.resource_added.connect(on_resource_gain)
	Hand.card_pool.clear() #clear previous game addittions
	for s in starting_pool:
		Hand.card_pool.append(s)
	
	for i in range(0,starting_cards):
		draw_one()
	
	draw_cost = 1

func draw_one():
	cards_in_hand += 1
	#Play card draw audio
	var card_deal_sound = FmodServer.create_event_instance("event:/Card Deal")
	card_deal_sound.start()
	card_deal_sound.release()
	
#	var breakpoint_readable_pool = card_pool
	var new_card:CardDisplay = CardDisplay.create_from_data(card_pool.pick_random().duplicate())
	new_card.draggable = true
	new_card.mouse_filter = Control.MOUSE_FILTER_PASS
	new_card.display()
	new_card.grabbed.connect(card_grabbed.emit)
	new_card.released.connect(card_released.emit)
	new_card.tree_exiting.connect(on_card_leaving_tree)
	container.add_child(new_card)


#func on_resource_gain(type:RM.types, amount:int):
	#if type != RM.types.BLUE:
		#return
	#
	#for i in range(0,amount):
		#draw_one()

func draw_fail():
	var deny_sound = FmodServer.create_event_instance("event:/UI Deny")
	deny_sound.start()
	deny_sound.release()
	pass

func _on_button_pressed() -> void:
	if cards_in_hand >= max_hand_size:
		draw_fail()
		return
	
	if RM.try_spend(RM.types.BLUE,draw_cost):
		var UI_confirm_sound = FmodServer.create_event_instance("event:/UI Confirm")
		UI_confirm_sound.start()
		UI_confirm_sound.release()
		draw_one()
	else:
		draw_fail()
	
func button_hover() -> void:
	var button_hover_sound = FmodServer.create_event_instance("event:/UI Hover")
	button_hover_sound.start()
	button_hover_sound.release()


func on_card_leaving_tree():
	cards_in_hand -= 1
	pass

#func _on_small_child_exiting_tree(node: Node) -> void:
	#print(node)
	#cards_in_hand -= 1
	#
	#pass # Replace with function body.
