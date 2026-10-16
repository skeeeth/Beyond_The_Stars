extends CanvasItem
class_name ResourceMap

signal move_request(direction:int)

@export var lane:Lane
@export var image_order:Array[RM.types]
@onready var above_type: TextureRect = $Above/AboveType
@onready var current_type: TextureRect = $"Current/Current Type"
@onready var below_type: TextureRect = $"Below/Below Type"

static func create():
	pass

func _ready() -> void:
	set_icons_in_lane(lane)
		#icons[i].texture = RM.resource_icons[image_order[i]]

func set_icons_in_lane(center:Lane):
	var icons:Array[TextureRect] = [above_type,current_type,below_type]
	for i in range(0,3):
		var adj_index:int = posmod(center.type - 1 + i,3)
		icons[i].texture = RM.resource_icons[adj_index]

func request_move(dir:int):
	move_request.emit(dir)

func _on_above_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("LMB"):
		request_move(-1)


func _on_below_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("LMB"):
		request_move(+1)
