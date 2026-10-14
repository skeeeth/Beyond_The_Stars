extends HBoxContainer
class_name WinListItem

@onready var label: Label = $Text
@onready var check_box: CheckBox = $CheckBox

func check():
	check_box.button_pressed = true
