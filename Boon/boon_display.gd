extends PanelContainer
class_name BoonDisplay

signal selected
signal finished

@export var boon:Boon

func set_boon(b:Boon):
	boon = b
	boon.finished.connect(finished.emit)

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("LMB"):
		boon.apply()
		selected.emit()
		
