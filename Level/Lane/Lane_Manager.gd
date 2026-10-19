extends Node2D

@export var lanes:Array[Lane]

@export var lane_spacing:float = 1600
@export var info_display:LaneInfoDisplay

@export var hand:Hand
@export var cam:Camera2D
var moving:bool = false
var lane_index:int = 1

func _ready() -> void:
	for i in range(lanes.size()):
		lanes[i].position.y = lane_spacing * i
		#lanes[i].resource_map.move_request.connect(move_camera)
		lanes[i].position.x = 0
		lanes[i].show()
		hand.card_grabbed.connect(lanes[i].midlight)
		hand.card_released.connect(lanes[i].dehighlight)
	#cam.global_position = lanes[1].camera_position.global_position
	
	info_display.move_request.connect(move_camera)
	center_lane(lanes[1])
	cam.make_current()
	
	

func move_camera(direction:int = 1):
	if moving:
		return
	
	moving = true
	var camera_move = create_tween()
	var target_lane:Lane = lanes[posmod(lane_index+direction,lanes.size())]
	
	camera_move.tween_property(cam,"global_position", target_lane.camera_position.global_position, 1.1).set_ease(Tween.EASE_IN_OUT)
	camera_move.tween_callback(center_lane.bind(target_lane))
	#cam.global_position = target_lane.camera_position.global_position
	lane_index += direction

func center_lane(lane:Lane):
	moving = false
	lane.position = Vector2.ZERO
	cam.global_position = lane.camera_position.global_position
	lanes[posmod(lane_index+1,lanes.size())].position.y = (lane.position.y + lane_spacing)
	lanes[posmod(lane_index-1,lanes.size())].position.y = lane.position.y - lane_spacing
	info_display.lane_entered(lane)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_up"):
		move_camera(-1)

	if event.is_action_pressed("debug_down"):
		move_camera(+1)
