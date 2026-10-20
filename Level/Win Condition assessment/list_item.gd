extends HBoxContainer
class_name WinListItem

signal cleared
signal button_pressed

@onready var label: Label = $Text
#@onready var check_box: CheckBox = $CheckBox
@onready var button: Button = $Button
var is_cleared:bool = false
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar

func check():
	if is_cleared:
		return
	texture_progress_bar.value = 1
	is_cleared = true
	#check_box.button_pressed = true
	cleared.emit()


func _on_button_pressed() -> void:
	button_pressed.emit()
