extends PanelContainer

@export var target_cult_size:int = 30

@onready var cult_size: WinListItem = $"Cult Size"

func _ready() -> void:
	RM.resource_added.connect(on_cultist_generated)
	
func on_cultist_generated(resource_type:RM.types, amount:int):
	if resource_type!= RM.types.BLUE:
		return
	
	cult_size.label.text = "Total members: %s/%s" % [RM.cumulative[RM.types.BLUE], target_cult_size]
