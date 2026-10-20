extends Node2D

@onready var color_rect: ColorRect = $"Start game/ColorRect"
var title_music_emitter

func _ready() -> void:
	title_music_emitter = get_node("/root/FmodBankManager/FmodEventEmitter2D")
	title_music_emitter.play()

func _on_start_game_pressed() -> void:
	start_game_sound()
	get_tree().change_scene_to_file("res://Level/World.tscn")
	pass # Replace with function body.


func _on_color_rect_mouse_entered() -> void:
	color_rect.modulate = Color(Color.WHITE,0.3)
	
	pass # Replace with function body.c


func _on_color_rect_mouse_exited() -> void:
	color_rect.modulate = Color(Color.WHITE,0)
	pass # Replace with function body.
	
func mouse_hover_sound() -> void:
	var UI_hover = FmodServer.create_event_instance("event:/UI Hover")
	UI_hover.start()
	UI_hover.release()
	
func start_game_sound() -> void:
	var start_confirm = FmodServer.create_event_instance("event:/Cycle Change")
	start_confirm.start()
	start_confirm.release()
	if has_node("/root/FmodBankManager"):
		title_music_emitter.stop()
