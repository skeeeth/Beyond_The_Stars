extends PanelContainer
class_name Craving

@onready var rich_text_label: RichTextLabel = $RichTextLabel


var resource_matrix:Dictionary[RM.types,int] = {
	RM.types.RED: 0,
	RM.types.GREEN: 0,
	RM.types.BLUE: 0,
}


var active:bool = false

func set_craving(tier:int):
	active = true
	visible = true
	match tier:
		_:
			set_resource_craving(tier)

func set_resource_craving(tier:int):
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
	if RM.try_spend_all(resource_matrix):
		on_satisfy()

func on_satisfy():
	active = false
	visible = false


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action("LMB"):
		try_pay()
		pass
