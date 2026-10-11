extends BaseCardStrategy
class_name GrubStrategy

@warning_ignore("unused_parameter")
func apply(card:CardData,lane:Lane,active_cards:Array[CardDisplay]):
	var display:CardDisplay = find_display(card,active_cards)
	var index:int = active_cards.find(display)
	if index == 0:
		return
	
	applied.emit()
	var previous_card = active_cards[index-1]
	var previous_data:CardData = previous_card.data
	display.request_removal()
	add_stats(previous_data,card.get_adjusted_abs_values(), card.get_adjusted_rel_values(), false)
	previous_card.display()
