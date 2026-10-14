extends HBoxContainer
class_name WinListItem

signal cleared
signal button_pressed

@onready var label: Label = $Text
@onready var check_box: CheckBox = $CheckBox
@onready var button: Button = $Button

func check():
	check_box.button_pressed = true
	cleared.emit()


func _on_button_pressed() -> void:
	button_pressed.emit()
