extends CardSelectBoon

@export var grow_pattern:CardData

func on_card_select(card_display:CardDisplay):
	BaseCardStrategy.add_stats(card_display.data,grow_pattern.get_adjusted_abs_values(),
		grow_pattern.get_adjusted_rel_values(),false,grow_pattern.get_adjusted_favor())
