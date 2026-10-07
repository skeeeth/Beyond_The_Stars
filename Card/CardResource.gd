extends Resource
class_name CardData

signal temp_values_cleared

@export var card_name:String = "Card Name"

@export var description:String = ""

@export var absolute_scoring:Dictionary[RM.types,int]  = {
	RM.types.RED: 0,
	RM.types.GREEN: 0,
	RM.types.BLUE: 0,
}

@export var relative_scoring:Dictionary[int,int] = {
	-1: 0,
	0: 0,
	1: 0,
}

@export var resource_costs:Dictionary[RM.types,int] = {
	RM.types.RED: 0,
	RM.types.GREEN: 1,
	RM.types.BLUE: 0,
}

@export var favor:int

@export var play_strategies:Array[BaseCardStrategy]

var temp_color_mod:Dictionary[RM.types,int]  = {
	RM.types.RED: 0,
	RM.types.GREEN: 0,
	RM.types.BLUE: 0,
}

var temp_grey_mod:Dictionary[int,int] = {
	-1: 0,
	0: 0,
	1: 0,
}

var static_color_mod:Dictionary[RM.types,int] = {
	RM.types.RED: 0,
	RM.types.GREEN: 0,
	RM.types.BLUE: 0,
}

var static_grey_mod:Dictionary[int,int] = {
	-1: 0,
	0: 0,
	1: 0,
}

func get_adjusted_abs_values() -> Dictionary[RM.types,int]:
	var return_value: Dictionary[RM.types,int]
	return_value = absolute_scoring.duplicate()
	for key in return_value:
		return_value[key] += temp_color_mod[key]
		return_value[key] += static_color_mod[key]
	return return_value

func get_adjusted_rel_values() -> Dictionary[int,int]:
	var return_value: Dictionary[int,int]
	return_value = relative_scoring.duplicate()
	for key in return_value:
		return_value[key] += temp_grey_mod[key]
		return_value[key] += temp_grey_mod[key]
	return return_value

func reset_temp_values():
	for i in temp_color_mod:
		temp_color_mod[i] = 0
		
	for i in temp_grey_mod:
		temp_grey_mod[i] = 0
	
	temp_values_cleared.emit()
