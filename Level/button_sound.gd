extends Button

func _hover_sound() -> void:
	var hover_sound_event = FmodServer.create_event_instance("event:/UI Hover")
	hover_sound_event.start()
	hover_sound_event.release()


func _on_great_feast_mouse_entered() -> void:
	pass # Replace with function body.
