extends BaseCardStrategy
class_name LinearGrowStrategy


@export var growth_pattern:CardData
@export var temp:bool = false
#var triggers:int = 0

@warning_ignore("unused_parameter")
func apply(card:CardData,lane:Lane,active_cards:Array[CardDisplay]):
	#triggers += 1
	#for i in range(0,triggers):
	add_stats(card,card.get_adjusted_abs_values(),card.get_adjusted_rel_values(), 
			temp, growth_pattern.get_adjusted_favor())
	
	applied.emit()
	#var color_dict = growth_pattern.absolute_scoring
	#for c in color_dict:
		#card.static_color_mod[c] += color_dict[c]
	#var grey_dict = growth_pattern.relative_scoring
	#for key in grey_dict:
		#card.static_grey_mod[key] += grey_dict[key]
	
