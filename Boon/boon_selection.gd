extends Node2D
class_name BoonSelection

signal finished

@onready var sprite_2d: Sprite2D = $God
@onready var background: Polygon2D = $Background
@onready var input_eater: ColorRect = $"Input Eater"

@onready var boon_container: VBoxContainer = $"Boon Container"

@export var boon_options:Array[BoonDisplay]
var texture:Texture
static var self_scene = preload("res://Boon/Boon Selection Screen.tscn")
var god:God

var card_picks_left:int = 0

var selection_effect:ViewportEffects.types = ViewportEffects.types.BUFF

static func create(_god:God, boon_pool:Array[Node],sprite:Texture) -> BoonSelection:
	var new_bs:BoonSelection = self_scene.instantiate()
	new_bs.texture = sprite
	new_bs.god = _god
	boon_pool.shuffle()
	var forced_boons:Array[Boon]
	for b:Boon in boon_pool:
		if b.debug_force:
			forced_boons.append(b)
	
	for b in forced_boons:
		boon_pool.erase(b)
		boon_pool.insert(0,b)
	
	boon_pool.resize(min(3,boon_pool.size()))
	
	for i in boon_pool.size():
		new_bs.boon_options[i].set_boon(boon_pool[i])
	
	for bd in new_bs.boon_options:
		if !bd.boon:
			bd.hide()
		
	return new_bs #...always some new bs

func _ready() -> void:
	scale = Vector2.ZERO
	for display in boon_options:
		display.finished.connect(ending)
		display.card_selection_requested.connect(card_selection_requested)
		display.lane_selection_requested.connect(lane_selection_requested)
		if display.boon:
			display.boon.request_select_effect.connect(set_selection_effect)
		display.god = god
	
	sprite_2d.texture = texture
	
	var grow_tween = create_tween()
	grow_tween.tween_property(self,"scale",Vector2.ONE,0.2)

func set_selection_effect(effect:ViewportEffects.types):
	selection_effect = effect

func card_selection_requested(_count:int):
	World.instance.request_lane_card_selection(selection_effect)
	
	selection_fade()

func lane_selection_requested():
	World.instance.request_lane_selection(selection_effect)
	selection_fade()

func selection_fade():
	boon_container.hide()
	
	var fade = self.create_tween()
	fade.tween_property(self,"modulate", Color(Color.WHITE,0.2), 0.5)
	#modulate = Color(Color.WHITE,0.2)
	input_eater.mouse_filter = Control.MOUSE_FILTER_IGNORE

func ending():
	var shrink_tween = create_tween()
	shrink_tween.tween_property(self,"scale",Vector2.ZERO,0.2)
	shrink_tween.tween_callback(finished.emit)
	shrink_tween.tween_callback(queue_free)
