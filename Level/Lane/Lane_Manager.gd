extends Node2D

@export var lanes:Array[Lane]

@export var lane_spacing:float = 1200

@export var cam:Camera2D

var lane_index:int = 0

func _ready() -> void:
	for i in range(lanes.size()):
		lanes[i].position.y = lane_spacing * i
		
	cam.global_position = lanes[0].camera_position.global_position
	cam.make_current()

func move_camera(direction:int = 1):
	var camera_move = create_tween()
	var target_lane:Lane = lanes[lane_index+direction]
	
	camera_move.tween_property(cam,"global_position", target_lane.camera_position.global_position, 1.0)
	#cam.global_position = target_lane.camera_position.global_position
	lane_index += direction



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_up"):
		move_camera(-1)

	if event.is_action_pressed("debug_down"):
		move_camera(+1)
