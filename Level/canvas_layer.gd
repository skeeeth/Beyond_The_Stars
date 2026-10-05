extends CenterContainer

# Close the pile preview on any click (press only, so releases and scroll wheel don't close it)
func _input(event):
	if visible and event is InputEventMouseButton and event.pressed \
			and event.button_index in [MOUSE_BUTTON_LEFT, MOUSE_BUTTON_RIGHT]:
		visible = false
