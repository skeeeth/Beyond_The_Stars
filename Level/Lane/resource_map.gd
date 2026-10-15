extends Container

@export var lane:Lane

@onready var above_type: TextureRect = $Above/AboveType
@onready var current_type: TextureRect = $"Current/Current Type"
@onready var below_type: TextureRect = $"Below/Below Type"

func _ready() -> void:
	var icons:Array[TextureRect] = [above_type,current_type,below_type]
	for i in range(0,2):
		var adj_index:int = posmod(lane.type - 1 + i,2)
		icons[i].texture = RM.resource_icons[adj_index]
		
