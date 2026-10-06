extends Label
class_name ActionManager

signal cycle_ending

@export var lanes:Array[Lane]
@export var hand:Hand

static var actions_per_cycle:int = 5
var actions_left:int = actions_per_cycle
var cycle:int = 0

func _ready() -> void:
	#we dont care what card or lane is actually being played here, just that it happened
	# hence the unbinding to match signature of triggered callable
	for l in lanes:
		l.card_added.connect(on_action_taken.unbind(1))
		l.lane_scored.connect(on_action_taken.unbind(1))

func on_action_taken():
	actions_left -= 1
	_set_text()
	if actions_left == 0:
		round_end()
		
func round_end():
	cycle_ending.emit()
	actions_left = actions_per_cycle
	cycle += 1
	_set_text()

func _set_text():
	text = "Actions Left: %s Cycle: %s" % [actions_left,cycle]
