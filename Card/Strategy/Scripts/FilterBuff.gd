extends BaseCardStrategy
class_name FilterBuffStrategy

@export var color_filter:Dictionary[RM.types,int]  = {
	RM.types.RED: 0,
	RM.types.GREEN: 0,
	RM.types.BLUE: 0,
}

@export var grey_filter:Dictionary[int,int] = {
	-1: 0,
	0: 0,
	1: 0,
}

@export var temp:bool = true

@export var buff:CardData

func apply(card:CardData,lane:Lane,active_cards:Array[CardDisplay]):
	for c in color_filter:
		if color_filter[c] > card.get_adjusted_abs_values()[c]:
			return
	
	
	
