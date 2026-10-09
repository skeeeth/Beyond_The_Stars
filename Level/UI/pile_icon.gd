extends Node2D
class_name Pile

@export var count:Label
var array:Array #passed in by REF

signal deck_clicked(cards: Array)
@export var highlighter:Highlighter
enum highlight_modes{PULSING, HOVERED, OFF, SELECTED}
var highlight_mode:highlight_modes

func update():
	count.text = str(array.size())

func set_highlight_mode(mode:highlight_modes):
	highlight_mode = mode
	match mode:
		highlight_modes.OFF:
			highlighter.state = Highlighter.pulse_states.STATIC
			highlighter.disable()
		highlight_modes.HOVERED:
			highlighter.state = Highlighter.pulse_states.STATIC
			highlighter.enable()
		highlight_modes.PULSING:
			highlighter.state = Highlighter.pulse_states.SLOW
		highlight_modes.SELECTED:
			highlighter.state = highlighter.pulse_states.STATIC
			highlighter.enable()



#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		## NOTE: Currently manually sized to the card pile, this is prone to break
		#if Rect2(0, 0, 151, 193).has_point(to_local(get_global_mouse_position())):
			#deck_clicked.emit(array)


@warning_ignore("unused_parameter")
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("LMB"):
		deck_clicked.emit(array)
		set_highlight_mode(highlight_modes.SELECTED)


func _on_area_2d_mouse_exited() -> void:
	if highlight_mode != highlight_modes.SELECTED:
		set_highlight_mode(highlight_modes.OFF)


func _on_hitbox_mouse_entered() -> void:
	if highlight_mode != highlight_modes.SELECTED:
		set_highlight_mode(highlight_modes.HOVERED)
