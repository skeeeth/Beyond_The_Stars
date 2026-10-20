extends Node2D

@onready var color_rect: ColorRect = $"Start game/ColorRect"

func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://Level/World.tscn")
	pass # Replace with function body.


func _on_color_rect_mouse_entered() -> void:
	color_rect.modulate = Color(Color.WHITE,0.3)
	
	pass # Replace with function body.c


func _on_color_rect_mouse_exited() -> void:
	color_rect.modulate = Color(Color.WHITE,0)
	pass # Replace with function body.
