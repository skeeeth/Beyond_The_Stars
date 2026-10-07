extends BaseCardStrategy
class_name FlatAddStrategy

@warning_ignore("unused_parameter")
func apply(card:CardData,lane:Lane,active_cards:Array[CardDisplay]):
	card.temp_grey_mod[0] += 1
