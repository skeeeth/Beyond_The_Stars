extends BaseCardStrategy
class_name TitheStrategy

@warning_ignore("unused_parameter")
func apply(card:CardData,lane:Lane,active_cards:Array[CardDisplay]):
	var color_negation_values = card.get_adjusted_abs_values()
	var grey_negation_values = card.get_adjusted_rel_values()
	
	var sum:int = 0
	for k in color_negation_values:
		var value = color_negation_values[k]
		card.temp_color_mod[k] -= value
		sum += color_negation_values[k]

	for k in grey_negation_values:
		var value = grey_negation_values[k]
		card.temp_grey_mod[k] -= value
		sum += value
	
	card.temp_favor_mod = sum * 5
	applied.emit()
