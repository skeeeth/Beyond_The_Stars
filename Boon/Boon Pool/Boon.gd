@abstract extends Node
class_name Boon

@warning_ignore("unused_signal")
signal finished

signal request_card_selections(count:int)

@export var description:String
@export var tier:int = 1

@export var mask:Dictionary[God.GODS,bool] = {
	God.GODS.A: false,
	God.GODS.B: false,
	God.GODS.C: false,
	God.GODS.D: false,
}

@abstract func apply(god:God)
