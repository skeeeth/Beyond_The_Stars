extends BaseCardStrategy
class_name WarriorStrategy

var warrior_keyword:Resource = preload("res://Card/Keywords/Warrior.tres")
func apply(card:CardData,lane:Lane,active_cards:Array[CardDisplay]):
	var count:int = 0
	for display_card in active_cards:
		if display_card.data.keywords.has(warrior_keyword):
			count += 1
	
	card.temp_color_mod[RM.types.RED] += count
	card.temp_favor_mod += count * 5
	applied.emit()
	
