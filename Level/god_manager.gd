extends Node
class_name GodManager

signal boon_selection_finished

@export var gods:Array[God]
@export var lanes:Array[Lane]

@export var action_manager:ActionManager

@onready var boon_pool: Node = $BoonPool
@onready var dummy_lane: Lane = $"Dummy Lane"


func _ready() -> void:
	action_manager.cycle_ending.connect(cycle)
	cycle()

func cycle():
	for g in gods:
		if g.tier_up_queued:
			g.tier_up()
			var pool = _get_valid_boons(g.identity,g.current_tier)
			var new_boon_selection:BoonSelection = BoonSelection.create(pool,g.true_sprite)
			add_child(new_boon_selection)
			await new_boon_selection.finished
	
	boon_selection_finished.emit()
	_shuffle_lanes()

func _get_valid_boons(god:God.GODS, tier:int) -> Array[Node]:
	var all_boons:Array[Node] = boon_pool.get_children()
	all_boons.filter(func(node): return node is Boon)
	all_boons.filter(func(b:Boon): return b.mask[god])
	all_boons.filter(func(b:Boon): return b.tier == tier)
	return all_boons


func _shuffle_lanes():
	gods.shuffle()
	for i in range(0,lanes.size()):
		gods[i].set_to_lane(lanes[i])
		
	gods.back().set_to_lane(dummy_lane)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_f"):
		cycle()
