extends Node2D
class_name Hand


static var card_pool:Array[CardData]
@export var starting_pool:Array[CardData]
@export var container:Container
@export var starting_cards:int = 3

func _ready() -> void:
	RM.resource_added.connect(on_resource_gain)
	for s in starting_pool:
		Hand.card_pool.append(s)
	
	for i in range(0,starting_cards):
		draw_one()

func draw_one():
	var new_card:CardDisplay = CardDisplay.create_from_data(card_pool.pick_random().duplicate())
	new_card.draggable = true
	container.add_child(new_card)


func on_resource_gain(type:RM.types, amount:int):
	if type != RM.types.BLUE:
		return
	
	for i in range(0,amount):
		draw_one()
