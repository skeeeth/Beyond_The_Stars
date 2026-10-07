extends Node2D
class_name God

var current_lane:Lane

enum GODS{A,B,C,D}
@export var identity:GODS

@export var favor:int = 25:
	set(v):
		favor = v
		%"Favor Bar".value = favor
		%"Favor Label".text = "%s/%s" % [favor,max_favor]
		if favor >= favor_tiers[current_tier]:
			queue_tier_up()
	get:
		return favor

@export var max_favor:int = 1000
@export var lane_sprite:Texture2D
@export var true_sprite:Texture2D
@onready var texture_rect: TextureRect = $VBoxContainer/TextureRect
@export var craving:Craving

static var favor_tiers:Array[int] = [0, 50, 125, 200, 500]
var current_tier:int = 0 #why the fuck did i call it this instead of just 'tier'???
var tier_up_queued:bool = false
#@export var boon_pool:Array[Boon]
@export var aura_strategies:Array[BaseCardStrategy]

func _ready() -> void:
	RM.favor_scored_in_lane.connect(on_favor_scored)
	
	favor = favor #trigger setter function
	texture_rect.texture = lane_sprite
	tier_up()

func set_to_lane(lane:Lane):
	#if current_lane:
		#current_lane.god_strategies.clear()
	
	current_lane = lane
	for s in aura_strategies:
		lane.god_strategies.append(s)
	
	var fly_tween = create_tween()
	fly_tween.tween_property(self,"global_position",lane.god_position.global_position,0.4)

func set_craving():
	if !craving.active:
		craving.set_craving(current_tier)


func on_favor_scored(type:RM.types, amount:int):
	if !type == current_lane.type:
		return
	
	favor += amount

func on_craving_fail():
	favor -= 100

func queue_tier_up():
	tier_up_queued = true

func tier_up():
	current_tier = min(current_tier + 1, favor_tiers.size()-1)
	tier_up_queued = false
	max_favor = favor_tiers[current_tier]
	%"Favor Bar".max_value = max_favor
	%"Favor Bar".min_value = favor_tiers[current_tier-1]

	favor = favor #calls setter to potentially queue an adittonal tier up
	
