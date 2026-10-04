extends Node2D
class_name Pile

@export var count:Label
var array:Array #passed in by REF

signal deck_clicked(cards: Array)

func update():
	count.text = str(array.size())

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# NOTE: Currently manually sized to the card pile, this is prone to break
		if Rect2(0, 0, 151, 193).has_point(to_local(get_global_mouse_position())):
			deck_clicked.emit(array)
