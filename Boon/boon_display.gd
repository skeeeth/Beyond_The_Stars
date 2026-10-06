extends PanelContainer
class_name BoonDisplay

signal selected
signal finished

@export var boon:Boon
@export var text_box: RichTextLabel


func set_boon(b:Boon):
	boon = b
	boon.finished.connect(finished.emit)
	text_box.text = (boon.description)


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("LMB"):
		boon.apply()
		selected.emit()
		
