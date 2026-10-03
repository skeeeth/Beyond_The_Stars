extends Control

@export var type:RM.types
@onready var label: Label = $Label

func _ready() -> void:
	RM.value_changed.connect(on_update)

func on_update(t,_v):
	if t != type: return #dont do anything for other types
	
	label.text = RM.names[type] + str(RM.current[type])
