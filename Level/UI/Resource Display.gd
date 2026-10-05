extends Control

@export var type:RM.types
@onready var label: Label = $Label

func _ready() -> void:
	RM.resource_added.connect(on_update)
	RM.resource_spend.connect(on_update)
	label.text = RM.names[type] + str(RM.current[type])

func on_update(t,_v):
	if t != type: return #dont do anything for other types
	
	label.text = RM.names[type] + ": %s (%s)" % [RM.current[type], RM.cumulative[type]]
