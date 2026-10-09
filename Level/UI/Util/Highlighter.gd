##helper class for setting borders around objects
##overwrites existing material on target objects
extends Node
class_name Highlighter

@export var canvas_group:CanvasGroup

@export var highlight_color:Color
var mat:ShaderMaterial #materiall girlll
@onready var highlight_material:ShaderMaterial = preload("res://Assets/Shaders/Highlightable.tres")

enum pulse_states{STATIC, SLOW}
var state:pulse_states
var pulse_progress:float = 0

func _ready() -> void:
	canvas_group.material = highlight_material.duplicate()
	mat = canvas_group.material
	
	set_thickness(4)
	disable()

func _process(delta: float) -> void:
	if state != pulse_states.STATIC:
		pulse_progress += delta * 1.4
		var a = lerp(0.2,1.0,abs(sin(pulse_progress)))
		set_border_color(Color(highlight_color,a))

func enable():
	mat.set_shader_parameter("line_color", highlight_color)

func set_border_color(col:Color):
	highlight_color = col
	mat.set_shader_parameter("line_color", col)

func set_thickness(width:float):
	mat.set_shader_parameter("line_thickness", width)

func disable():
	mat.set_shader_parameter("line_color", Color(Color.WHITE,0))
