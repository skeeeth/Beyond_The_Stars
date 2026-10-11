extends CardSelectBoon


func on_card_select(card_display:CardDisplay):
	card_display.data.static_color_mod[RM.types.GREEN] = 1
