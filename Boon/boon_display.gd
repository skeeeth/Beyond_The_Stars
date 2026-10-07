extends PanelContainer
class_name BoonDisplay

signal selected
signal finished

@export var boon:Boon
@export var text_box: RichTextLabel
@export var title_box:Label

var god:God

func set_boon(b:Boon):
	boon = b
	boon.finished.connect(finished.emit)
	text_box.text = (boon.description)
	title_box.text = boon.name

func format_text(_text:String):
	pass


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("LMB"):
		boon.apply(god)
		selected.emit()
		
