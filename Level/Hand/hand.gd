extends Node2D
class_name Hand

static var card_pool:Array[CardData]
@export var starting_pool:Array[CardData]
@export var container:Container
@export var starting_cards:int = 3

var draw_cost:int = 0:
	set(v):
		draw_cost = v
		button.text = "Draw card (%s cultists)" % draw_cost
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
	
	draw_cost = 0

func draw_one():
	#Play card draw audio
	var card_deal_sound = FmodServer.create_event_instance("event:/Card Deal")
	card_deal_sound.start()
	card_deal_sound.release()
	
	#var breakpoint_readable_pool = card_pool
	var new_card:CardDisplay = CardDisplay.create_from_data(card_pool.pick_random().duplicate())
	new_card.draggable = true
	new_card.mouse_filter = Control.MOUSE_FILTER_PASS
	new_card.display()
	container.add_child(new_card)



#func on_resource_gain(type:RM.types, amount:int):
	#if type != RM.types.BLUE:
		#return
	#
	#for i in range(0,amount):
		#draw_one()


func _on_button_pressed() -> void:
	if RM.try_spend(RM.types.BLUE,draw_cost):
		var UI_confirm_sound = FmodServer.create_event_instance("event:/UI Confirm")
		UI_confirm_sound.start()
		UI_confirm_sound.release()
		draw_one()
		draw_one()
	
func button_hover() -> void:
	var button_hover_sound = FmodServer.create_event_instance("event:/UI Hover")
	button_hover_sound.start()
	button_hover_sound.release()
