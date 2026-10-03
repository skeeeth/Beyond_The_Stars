extends Node2D
class_name Pile

@export var count:Label
var array:Array #passed in by REF

func update():
	count.text = str(array.size())
