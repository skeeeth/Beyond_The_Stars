@abstract extends Node
class_name Boon

@warning_ignore("unused_signal")
signal finished

@warning_ignore("unused_signal")
signal request_card_selections(count:int)

@warning_ignore("unused_signal")
signal request_lane_select

@warning_ignore("unused_signal")
signal request_select_effect(effect:ViewportEffects.types)

@export var description:String
@export var icon:Texture2D
@export var tier:int = 1

@export var debug_force:bool = false

@export var mask:Dictionary[God.GODS,bool] = {
	God.GODS.A: false,
	God.GODS.B: false,
	God.GODS.C: false,
	God.GODS.D: false,
}

@abstract func apply(god:God)

func disable():
	for key in mask:
		mask[key] = false
