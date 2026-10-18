extends BaseCardStrategy
class_name GrowKeywordStrategy

@warning_ignore("unused_parameter")
func apply(card:CardData,lane:Lane,active_cards:Array[CardDisplay]):
	
	var filter_add = func(read:Dictionary,write:Dictionary):
		for key in read:
			if read[key] > 0:
				write[key] += 1

	filter_add.call(card.get_adjusted_abs_values(),card.static_color_mod)
	filter_add.call(card.get_adjusted_rel_values(),card.static_grey_mod)
	
	applied.emit()
