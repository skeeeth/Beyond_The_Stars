extends Control
class_name GameEnd

var win_text:String = "You Win!"
var lose_text:String = "You Lost"

#var win_checklist:WinChecklist
@onready var checklist_position: Node2D = $"Checklist Position"
@onready var text_box: Label = $"Text Box"

static var instance:GameEnd

func _ready() -> void:
	instance = self

static func activate(checklist:WinChecklist):
	instance.setup(checklist)

func setup(checklist:WinChecklist):
	visible = true
	checklist.reparent(checklist_position,false)
	if checklist.clears_left == 0:
		display_text(win_text)
	else:
		display_text(lose_text)

func display_text(text:String):
	#TODO: when the texts are multi-lane narritve blocks we can tween text_box.max_lines_visible
	text_box.text = text


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Level/Game End/main_menu.tscn")
