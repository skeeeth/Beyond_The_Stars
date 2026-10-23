extends PanelContainer
class_name BoonHistoryDisplay

#@onready var container: BoxContainer = $Container
@export var displays:Array[BoonDisplay]
@export var locked_boon:Boon

@onready var god_identifier: Label = $"Container/God Identifier"

func _ready() -> void:
	#for node in container.get_children():
		#displays.append(node)
	
	var empty_stylebox:StyleBox = StyleBoxEmpty.new()
	for d in displays:
		d.mouse_filter = Control.MouseFilter.MOUSE_FILTER_IGNORE
		d.add_theme_stylebox_override("panel", empty_stylebox)
		
	display_boons([])

func display_boons(boons:Array[Boon]):
	var i:int = 0
	for b in boons:
		displays[i].set_boon(b)
		i += 1
	
	while i < God.favor_tiers.size()-1:
		displays[i].set_boon(locked_boon)
		displays[i].hide_body()
		i += 1
