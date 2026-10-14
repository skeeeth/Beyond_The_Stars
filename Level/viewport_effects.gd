extends Node2D
class_name ViewportEffects

enum types{SACRIFICE,BUFF}
@onready var edge_light: PointLight2D = $"Edge Light"
@export var sacrifice_color:Color
@export var buff_color:Color

func apply_type(type:types):
	match type:
		types.SACRIFICE:
			edge_light.color = sacrifice_color
			create_tween().tween_property(edge_light,"energy",1.0,1.0)
			FmodServer.set_global_parameter_by_name("BGM_Filter", 35.0)
		types.BUFF:
			edge_light.color = buff_color
			create_tween().tween_property(edge_light,"energy",0.5,1.0)

func cancel(type:types):
	match type:
		_:
			create_tween().tween_property(edge_light,"energy",0.0,1.0)
			FmodServer.set_global_parameter_by_name("BGM_Filter", 100.0)
