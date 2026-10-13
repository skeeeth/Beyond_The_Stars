extends CardSelectBoon

@export var keyword:Keyword

func _ready() -> void:
	description += "\n" + keyword.word + " - " + keyword.description

func on_card_select(card_display:CardDisplay):
	card_display.data.keywords.append(keyword)
	card_display.display()
