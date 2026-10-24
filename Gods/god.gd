extends Node2D
class_name God

var current_lane:Lane

enum GODS{A,B,C,D}

const god_names:Dictionary[GODS,String] = {
	GODS.A: "Gan'th",
	GODS.B: "Kolma",
	GODS.C: "Myggos",
	#GODS.D: "Mahuax"
}

@export var identity:GODS


@export var favor:int = 25:
	set(v):
		favor = v
		%"Favor Bar".value = favor
		%"Favor Label".text = "%s/%s" % [favor,max_favor]
		if current_tier == favor_tiers.size():
			return
		if favor >= favor_tiers[current_tier]:
			queue_tier_up()
	get:
		return favor

@export var max_favor:int = 1000
@export var lane_sprite:Texture2D
@export var middle_sprite:Texture2D
@export var true_sprite:Texture2D
#@export var nav_icon:Texture2D
@export var texture_rect: TextureRect
@export var craving:Craving

static var favor_tiers:Array[int] = [0, 50, 125, 200]
var current_tier:int = 0 #why the fuck did i call it this instead of just 'tier'???
var tier_up_queued:bool = false
#@export var boon_pool:Array[Boon]
@export var aura_strategies:Array[BaseCardStrategy]
@export var highlighter:Highlighter
@onready var boon_display: BoonHistoryDisplay = $"Boon History"

static var god_tiers:Dictionary[God.GODS, int] ={
	GODS.A: 0,
	GODS.B: 0,
	GODS.C: 0,
	#GODS.D: 0
}

var boon_history:Array[Boon]

func _ready() -> void:
	RM.favor_scored_in_lane.connect(on_favor_scored)
	
	favor = favor #trigger setter function
	texture_rect.texture = lane_sprite
	craving.craving_failed.connect(on_craving_fail)
	tier_up.call_deferred()
	boon_display.god_identifier.text += god_names[identity]


func set_to_lane(lane:Lane):
	reparent(lane)
	#if current_lane:
		#current_lane.god_strategies.clear()
	#lane.god = self
	current_lane = lane
	for s in aura_strategies:
		lane.god_strategies.append(s)
		
	for con_dict in lane.favor_bubble_created.get_connections():
		var sig:Signal = con_dict["signal"]
		var callable:Callable = con_dict["callable"]
		sig.disconnect(callable)
	lane.favor_bubble_created.connect(fly_bubble)
	#print(lane.favor_bubble_created.get_connections())
	
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
	if current_tier  >= favor_tiers.size():
		return
	
	tier_up_queued = true

func tier_up():
	current_tier = min(current_tier + 1, favor_tiers.size())
	tier_up_queued = false
	if current_tier > 1:
		boon_display.displays[current_tier-2].modulate = Color.WHITE #reshow hidden icon
	
	if current_tier == 4:
		%"Favor Bar".hide()
		return

	max_favor = favor_tiers[current_tier]
	
	god_tiers[identity] = current_tier
	

	var tier_icon = boon_display.displays[current_tier-1]
	tier_icon.modulate = Color(Color.WHITE,0) #hide covered boon icon
	var icon_position = boon_display.displays[current_tier-1].icon.global_position
	#var extra_offset = (Vector2(102,0)) #this shit is based on NOTHING will break easily
	%"Favor Bar".global_position = icon_position #+ extra_offset
	%"Favor Bar".max_value = max_favor
	%"Favor Bar".min_value = favor_tiers[current_tier-1]

	
	favor = favor #calls setter to potentially queue an adittonal tier up

func recieve_boon(boon:Boon):
	boon_history.append(boon)
	boon_display.display_boons(boon_history)

func fly_bubble(bubble:Control):
	var fly = create_tween()
	fly.tween_property(bubble,"global_position",%"Favor Bar".global_position,0.3).set_ease(Tween.EASE_IN_OUT)
	fly.tween_callback(bubble.queue_free)
	

func _on_v_box_container_mouse_entered() -> void:
	pass
	#boon_display.visible = true


func _on_v_box_container_mouse_exited() -> void:
	pass
	#boon_display.visible = false
