extends Resource
class_name CardData

@export var absolute_scoring:Dictionary[RM.types,int]  = {
	RM.types.RED: 0,
	RM.types.GREEN: 0,
	RM.types.BLUE: 0,
}


@export var relative_scoring:Dictionary[int,int] = {
	-1: 0,
	0: 0,
	1: 0,
}
