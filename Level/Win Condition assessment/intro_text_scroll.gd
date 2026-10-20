extends Control

@export var label: TextScroll
var opening_text_path = "res://Assets/Text Scrolls/Opening.txt"

func _ready() -> void:
	await label.set_text_from_path(opening_text_path)
	end()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Space"):
		end()

func end():
	var fade = self.create_tween()
	fade.tween_property(self,"modulate",Color(Color.WHITE,0),2.0)
	fade.tween_callback(queue_free)
