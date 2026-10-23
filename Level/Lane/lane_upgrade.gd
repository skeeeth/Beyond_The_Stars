extends Button

@export var lane:Lane

@export var cost_progression:Array[int]
var current_stage:int = 0
var cost_type:RM.types
@onready var cost_label: Label = $"Cost/Cost Label"
@export var resource_map_base:ResourceMap

func _ready() -> void:
	_update_text()
	resource_map_base.visible = false
	upgrade_silent()
	upgrade_silent()

func _on_pressed() -> void:
	if !RM.try_spend(cost_type,cost_progression[current_stage]): 
		var deny_sound = FmodServer.create_event_instance("event:/UI Deny")
		deny_sound.start()
		deny_sound.release()
		return #do nothing on fail (or later to some kind of error feedback but nothing for now)
	
	var UI_confirm_sound = FmodServer.create_event_instance("event:/UI Confirm")
	UI_confirm_sound.start()
	UI_confirm_sound.release()
	upgrade_silent()


func upgrade_silent():

	current_stage +=1 
	lane.gain_upgrade()
	var resource_map = resource_map_base.duplicate()
	resource_map.position = position
	resource_map.visible = true
	lane.add_child.call_deferred(resource_map)
	
	position.x += CardDisplay.card_size.x# + lane.x_spacing
	if current_stage >= cost_progression.size():
		queue_free()
	else:
		_update_text()
func _update_text():
	#text = "Upgrade play number (%s money)" % cost_progression[current_stage]
	cost_label.text = ": %s" %  cost_progression[current_stage]
