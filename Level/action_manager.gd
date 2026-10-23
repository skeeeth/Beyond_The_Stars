extends Label
class_name ActionManager

signal cycle_ending

@export var lanes:Array[Lane]
@export var hand:Hand
@export var gm:GodManager
@export var win_checklist:WinChecklist
@export var cycle_text:Label
static var actions_per_cycle:int = 5
static var instance:ActionManager
var actions_left:int = actions_per_cycle
var cycle:int = 0
@export var bgm_node: FmodEventEmitter2D

func _ready() -> void:
	ActionManager.instance = self
	
	#we dont care what card or lane is actually being played here, just that it happened
	# hence the unbinding to match signature of triggered callable
	
	for l in lanes:
		#l.card_added.connect(on_action_taken.unbind(1))
		l.lane_scored.connect(on_action_taken.unbind(1))
	gm.boon_selection_finished.connect(start_cycle)
	_set_text()

func on_action_taken():
	actions_left -= 1
	_set_text()
	if actions_left == 0:
		round_end()
		
func round_end():
	cycle_ending.emit()
	for l in lanes:
		l.disable_buttons()

func start_cycle():
	if cycle == 7:
		GameEnd.activate(win_checklist)
		return
		
	for l in lanes:
		l.enable_buttons()
	
	actions_left = actions_per_cycle
	cycle += 1

		
	if (cycle % 2) == 1:
		hand.draw_cost += 1
	bgm_node.set_parameter("Cycle", cycle)
	_set_text()
	_set_cycle_text()

func _set_text():
	text = "%s" % actions_left
	
func _set_cycle_text():
	cycle_text.text = "%s" % cycle
