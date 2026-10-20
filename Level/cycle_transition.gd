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
	var cycle_transition_sound = FmodServer.create_event_instance("event:/Cycle Change")
	cycle_transition_sound.start()
	cycle_transition_sound.release()
	await fade_background(true)
	await create_tween().tween_property(cycle_finished_text,"modulate",Color(Color.WHITE,0),1.0).finished
	step_finished.emit()

func finish():
	if game_start_cycle:
		step_finished.emit.call_deferred()
		game_start_cycle = false
		return
	var exit_transition_sound = FmodServer.create_event_instance("event:/Cycle Transition End")
	exit_transition_sound.start()
	exit_transition_sound.release()
	fade_background(false)
	step_finished.emit()

func fade_background(fade_in:bool = true,time:float = 2.0, end_opacity:float = 1.0) -> Signal:
	var start_value:float = +1
	var end_value:float = -end_opacity
	
	if fade_in:
		start_value = -1
		end_value = end_opacity

	var rssp = func reverse_set_shader_parameter(value:float,parameter:String):
		background_material.set_shader_parameter(parameter,value)
	
	var fade = self.create_tween()
	fade.tween_method(rssp.bind("fade"),start_value, end_value, time)
	return fade.finished

func fade_out_requested(end_opacity:float):
	fade_background(false,2.0,end_opacity)
