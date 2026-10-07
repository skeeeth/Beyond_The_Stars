extends PanelContainer
class_name Craving

enum craving_types{RES, LANE, HAND}
var type:craving_types

@onready var rich_text_label: RichTextLabel = $RichTextLabel

var resource_matrix:Dictionary[RM.types,int] = {
	RM.types.RED: 0,
	RM.types.GREEN: 0,
	RM.types.BLUE: 0,
}


var active:bool = false
var time_limit:int = 2

func set_craving(tier:int):
	active = true
	visible = true
	match tier:
		_:
			set_resource_craving(tier)

func set_resource_craving(tier:int):
	set_card_craving()
	return
	match tier:
		1, 2:
			var key = resource_matrix.keys().pick_random()
			resource_matrix[key] = tier  * 3
		_:
			var keys = [0,1,2]
			keys.shuffle()
			keys = keys.slice(0,2)
			for i in keys:
				resource_matrix[i] = tier * 5
		
	display_card_craving()

func set_card_craving():
	type = craving_types.LANE
	rich_text_label.text = "Hungry for card"

func display_card_craving():
	var string:String = ""
	for i in resource_matrix:
		if resource_matrix[i] == 0:
			continue
		var new_text:String = RM.names[i]
		new_text += ": %s \n" % resource_matrix[i]
		string += new_text
		
	rich_text_label.text = string

func try_pay():
	if type == craving_types.LANE:
		World.instance.request_lane_card_selection()
		World.instance.splayed_card_clicked.connect(on_card_selected,4)
		
	else:
		if RM.try_spend_all(resource_matrix):
			on_satisfy()

func on_satisfy():
	active = false
	visible = false

func on_card_selected(card_display:CardDisplay):
	World.instance.current_list.erase(card_display.data)
	on_satisfy()

func on_unsated_cycle():
	time_limit -= 1
	if time_limit == 0:
		pass

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("LMB"):
		try_pay()
		pass
