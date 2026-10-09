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

@warning_ignore("unused_parameter")
func apply(card:CardData,lane:Lane,active_cards:Array[CardDisplay]):
	for c in color_filter:
		if color_filter[c] > card.get_adjusted_abs_values()[c]:
			return
	
	for i in grey_filter:
		if grey_filter[i] > card.get_adjusted_rel_values()[i]:
			return
	
	#only register applied applied if passed filters
	applied.emit()
	var color_array = card.temp_color_mod if temp else card.static_color_mod
	var rel_array = card.temp_grey_mod if temp else card.static_grey_mod
	
	for c in buff.absolute_scoring:
		color_array[c] += buff.absolute_scoring[c]
	
	for i in buff.relative_scoring:
		rel_array[i] += buff.relative_scoring[i]
	
