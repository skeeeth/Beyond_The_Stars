@abstract extends Node
class_name Boon

@export var description:String

@abstract func apply()

@warning_ignore("unused_signal")
signal finished
