extends PanelContainer
class_name BoonHistoryDisplay

@onready var container: VBoxContainer = $Container
var displays:Array[BoonDisplay]
@export var locked_boon:Boon

func _ready() -> void:
	for node in container.get_children():
		displays.append(node)
	
	for d in displays:
		d.mouse_filter = Control.MOUSE_FILTER_PASS
		
	display_boons([])

func display_boons(boons:Array[Boon]):
	var i:int = 0
	for b in boons:
		displays[i].set_boon(b)
		i += 1
	
	while i < God.favor_tiers.size():
		displays[i].set_boon(locked_boon)
		displays[i].hide_body()
		i += 1
