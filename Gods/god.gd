extends Node2D
class_name God

var current_lane:Lane

@export var favor:int = 25:
	set(v):
		favor = v
		%"Favor Bar".value = favor
		%"Favor Label".text = "%s/%s" % [favor,max_favor]
		if favor > favor_tiers[0]:
			queue_tier_up()
	get:
		return favor

@export var max_favor:int = 1000


static var favor_tiers:Array[int] = [50, 125, 200, 500]
var current_tier:int = 0
var tier_up_queued:bool = false
@export var boon_pool:Array[Boon]

func _ready() -> void:
	RM.favor_scored_in_lane.connect(on_favor_scored)
	
	favor = favor #trigger setter function

func set_to_lane(lane:Lane):
	current_lane = lane
	var fly_tween = create_tween()
	fly_tween.tween_property(self,"global_position",lane.god_position.global_position,0.4)


func on_favor_scored(type:RM.types, amount:int):
	if !type == current_lane.type:
		return
	
	favor += amount

func queue_tier_up():
	tier_up_queued = true

func tier_up():
	current_tier = min(current_tier + 1, favor_tiers.size()-1)
	tier_up_queued = false
	max_favor = favor_tiers[current_tier]
	favor = favor #calls setter to potentially queue an adittonal tier up
	
