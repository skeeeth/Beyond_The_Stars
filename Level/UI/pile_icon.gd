extends Node2D
class_name Pile

@export var count:Label
var array:Array #passed in by REF

signal deck_clicked(cards: Array)
@export var highlighter:Highlighter
enum highlight_modes{PULSING, HOVERED, OFF, SELECTED}
var highlight_mode:highlight_modes
@onready var card_1: PanelContainer = $CanvasGroup/Card1
@onready var card_2: PanelContainer = $CanvasGroup/Card2

func update():
	count.text = str(array.size())
	if array.size() == 1:
		card_1.show()
		card_2.hide()
	elif array.size() == 0:
		card_1.hide()
		card_2.hide()
	else:
		card_1.show()
		card_2.show()

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
		if array.size() > 0:
			set_highlight_mode(highlight_modes.SELECTED)


func _on_area_2d_mouse_exited() -> void:
	if highlight_mode != highlight_modes.SELECTED:
		set_highlight_mode(highlight_modes.OFF)


func _on_hitbox_mouse_entered() -> void:
	if highlight_mode != highlight_modes.SELECTED:
		set_highlight_mode(highlight_modes.HOVERED)
		var UI_hover_sound = FmodServer.create_event_instance("event:/UI Hover")
		UI_hover_sound.start()
		UI_hover_sound.release()

func fly_in_card(card:CardDisplay):
	var fly = self.create_tween() #haikyu reference !!??!??11!!1!
	fly.tween_property(card,"position",position,0.5)
	fly.parallel().tween_property(card,"scale",Vector2.ZERO,0.5)
	fly.parallel().tween_callback(shuffle_tween_anim)

func shuffle_tween_anim() -> Signal:
	var shuffle = self.create_tween()
	var card_one = $CanvasGroup/Card1
	var card_two = $CanvasGroup/Card2
	var p1 = Vector2(5,-5)
	var p2 = -p1
	var target_z = 1
	for i in range(0,3):
		shuffle.tween_property(card_one,"position",p1,0.2)
		shuffle.parallel().tween_property(card_two,"position",p2,0.2)
		shuffle.tween_property(card_one,"z_index",target_z,0)
		p1 *= -1
		p2 *= -1
		target_z *= -1
	shuffle.tween_property(card_one,"position", Vector2.ZERO, 0.05)
	shuffle.tween_property(card_two,"position", Vector2.ZERO, 0.05)
	return shuffle.finished

func pop_card_data(data:CardData) -> CardDisplay:
	var new_card = CardDisplay.create_from_data(data)
	new_card.position = position
	add_sibling(new_card)
	return new_card
