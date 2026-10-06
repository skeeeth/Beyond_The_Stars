extends Node

@export var gods:Array[God]
@export var lanes:Array[Lane]
@export var action_manager:ActionManager



func _ready() -> void:
	action_manager.cycle_ending.connect(cycle)
	cycle()

func cycle():
	for g in gods:
		if g.tier_up_queued:
			g.tier_up()
			var new_boon_selection:BoonSelection = BoonSelection.create(g.boon_pool)
			add_child(new_boon_selection)
			await new_boon_selection.finished
	
	_shuffle_lanes()


func _shuffle_lanes():
	gods.shuffle()
	for i in range(0,lanes.size()):
		gods[i].set_to_lane(lanes[i])

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_f"):
		cycle()
