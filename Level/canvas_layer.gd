extends CenterContainer


# Close the pile preview on any click (press only, so releases and scroll wheel don't close it)
#func _input(event: InputEvent) -> void:
	#if visible and event is InputEventMouseButton and event.pressed \
			#and event.button_index in [MOUSE_BUTTON_LEFT, MOUSE_BUTTON_RIGHT]:
	###if event.is_action_pressed("LMB"):
		#visible = false

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("LMB") and visible:
		disappear()

func display():
	visible = true
	set_deferred("mouse_filter", Control.MOUSE_FILTER_STOP)
	#mouse_filter = Control.MOUSE_FILTER_STOP

func disappear():
	visible = false
	set_deferred("mouse_filter", Control.MOUSE_FILTER_IGNORE)
	for l in World.instance.lane_list:
		l.pile_highlight_reset()
	#mouse_filter = Control.MOUSE_FILTER_IGNORE
