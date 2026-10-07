extends Node2D
class_name BoonSelection

signal finished

@onready var sprite_2d: Sprite2D = $Sprite2D
@export var boon_options:Array[BoonDisplay]
var texture:Texture
static var self_scene = preload("res://Boon/Boon Selection Screen.tscn")
var god:God

static func create(_god:God, boon_pool:Array[Node],sprite:Texture) -> BoonSelection:
	var new_bs:BoonSelection = self_scene.instantiate()
	new_bs.texture = sprite
	new_bs.god = _god
	boon_pool.shuffle()
	for i in range(0,3):
		new_bs.boon_options[i].set_boon(boon_pool[i])
	
	return new_bs #...always some new bs

func _ready() -> void:
	scale = Vector2.ZERO
	for display in boon_options:
		display.finished.connect(ending)
		display.god = god
	
	sprite_2d.texture = texture
	
	var grow_tween = create_tween()
	grow_tween.tween_property(self,"scale",Vector2.ONE,0.2)


func ending():
	var shrink_tween = create_tween()
	shrink_tween.tween_property(self,"scale",Vector2.ZERO,0.2)
	shrink_tween.tween_callback(finished.emit)
	shrink_tween.tween_callback(queue_free)
