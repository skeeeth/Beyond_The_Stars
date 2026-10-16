extends Sprite2D
class_name CycleFinishAnimator

signal step_finished

var background_material:ShaderMaterial
@onready var cycle_finished_text: Label = $"Cycle Finished Text"

var game_start_cycle:bool = true
func _ready() -> void:
	background_material = material

func start():
	if game_start_cycle:
		step_finished.emit.call_deferred()
		return
	
	create_tween().tween_property(cycle_finished_text,"modulate",Color(Color.WHITE),1.0)
	await fade_background(true)
	await create_tween().tween_property(cycle_finished_text,"modulate",Color(Color.WHITE,0),1.0).finished
	step_finished.emit()

func finish():
	if game_start_cycle:
		step_finished.emit.call_deferred()
		game_start_cycle = false
		return
	fade_background(false)
	step_finished.emit()

func fade_background(fade_in:bool = true,time:float = 2.0) -> Signal:
	var start_value:float = +1
	var end_value:float = -1
	
	if fade_in:
		start_value = -1
		end_value = +1

	var rssp = func reverse_set_shader_parameter(value:float,parameter:String):
		background_material.set_shader_parameter(parameter,value)
	
	var fade = self.create_tween()
	fade.tween_method(rssp.bind("fade"),start_value, end_value, time)
	return fade.finished
