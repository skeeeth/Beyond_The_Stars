extends Node2D
class_name Lane

@export var type:RM.types

@export var deck:Array[CardData]
var discard:Array[CardData]

var active_cards:Array[CardDisplay]
var x_spacing = 25

func draw_card():
	var res = deck.pop_front()
	discard.push_back(res)
	
	var new_card = CardDisplay.create_from_data(res)
	add_child(new_card)
	active_cards.append(new_card)
	var draw_slide = create_tween()
	var destination = Vector2(active_cards.size() * (CardDisplay.card_size.x + x_spacing),0)
	draw_slide.tween_property(new_card,"position",destination,0.2).set_ease(Tween.EASE_OUT)
	new_card.score(type)
	
	#reshuffle
	if deck.size() == 0:
		deck = discard.duplicate()
		deck.shuffle()
		discard.clear()


func _on_button_pressed() -> void:
	draw_card()
	pass # Replace with function body.
