extends Node2D
class_name ViewportEffects

enum types{SACRIFICE,BUFF}
@onready var sacrifice_vision: PointLight2D = $"Sacrifice Vision"

func apply_type(type:types):
	match type:
		types.SACRIFICE:
			create_tween().tween_property(sacrifice_vision,"energy",1.0,1.0)
			FmodServer.set_global_parameter_by_name("BGM_Filter", 35.0)
			

func cancel(type:types):
	match type:
		types.SACRIFICE:
			create_tween().tween_property(sacrifice_vision,"energy",0.0,1.0)
			FmodServer.set_global_parameter_by_name("BGM_Filter", 100.0)
