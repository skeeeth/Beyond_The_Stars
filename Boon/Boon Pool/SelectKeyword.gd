extends CardSelectBoon


@export var keyword:Keyword

func on_card_select(card_display:CardDisplay):
	card_display.data.keywords.append(keyword)
	card_display.display()
