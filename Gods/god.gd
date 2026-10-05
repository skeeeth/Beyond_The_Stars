extends Node2D
class_name God

var current_lane:Lane

var favor:int = 25:
	set(v):
		favor = v
		%"Favor Bar".value = favor
	get:
		return favor

func _ready() -> void:
	RM.favor_scored_in_lane.connect(on_favor_scored)


func set_to_lane(lane:Lane):
	current_lane = lane
	var fly_tween = create_tween()
	fly_tween.tween_property(self,"global_position",lane.god_position.global_position,0.4)


func on_favor_scored(type:RM.types, amount:int):
	if !type == current_lane.type:
		return
	
	favor += amount
	
	
