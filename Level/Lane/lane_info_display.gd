extends Node2D
class_name LaneInfoDisplay

signal move_request(direction:int)

@export var up_arrow: TextureRect
@export var down_arrow: TextureRect
@export var radio_buttons:Array[CheckBox]

func _ready() -> void:
	up_arrow.gui_input.connect(_on_above_gui_input)
	down_arrow.gui_input.connect(_on_below_gui_input)

func request_move(dir:int):
	move_request.emit(dir)

func _on_above_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("LMB"):
		request_move(-1)


func _on_below_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("LMB"):
		request_move(+1)

func lane_entered(lane:Lane):
	var button = radio_buttons[lane.type]
	if button:
		button.button_pressed = true

func _on_up_button_pressed() -> void:
	request_move(-1)


func _on_down_button_pressed() -> void:
	request_move(-1)
