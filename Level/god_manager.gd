extends Node

@export var gods:Array[God]
@export var lanes:Array[Lane]

func _ready() -> void:
	cycle()

func cycle():
	gods.shuffle()
	for i in range(0,lanes.size()):
		gods[i].set_to_lane(lanes[i])


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_f"):
		cycle()
