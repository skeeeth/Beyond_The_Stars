@abstract extends Node
class_name Boon

@export var description:String
@export var tier:int = 1

@export var mask:Dictionary[God.GODS,bool] = {
	God.GODS.A: false,
	God.GODS.B: false,
	God.GODS.C: false,
	God.GODS.D: false,
}

@abstract func apply(god:God)

@warning_ignore("unused_signal")
signal finished
