extends Button

@export var lane:Lane

@export var cost_progression:Array[int]
var current_stage:int = 0
var cost_type:RM.types


func _ready() -> void:
	_update_text()

func _on_pressed() -> void:
	if !RM.try_spend(cost_type,cost_progression[current_stage]): 
		return #do nothing on fail (or later to some kind of error feedback but nothing for now)
	
	current_stage +=1 
	lane.gain_upgrade()
	if current_stage >= cost_progression.size():
		queue_free()
	else:
		_update_text()
	

func _update_text():
	text = "Upgrade play number (%s money)" % cost_progression[current_stage]
