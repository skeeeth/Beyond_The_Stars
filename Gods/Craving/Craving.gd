extends PanelContainer
class_name Craving

enum craving_types{RES, LANE, HAND}
var type:craving_types

@export var card_odds_per_tier:Array[float]
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
	var card_odds:float = 0.0
	
	
	if randf() < card_odds:
		set_resource_craving(tier)
	else:
		set_card_craving(tier)

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

func set_card_craving(_tier):
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
		World.instance.request_lane_card_selection(ViewportEffects.types.SACRIFICE)
		#World.instance.viewport_effects.apply_type(ViewportEffects.types.SACRIFICE)
		World.instance.splayed_card_clicked.connect(on_card_selected,4)
	else:
		if RM.try_spend_all(resource_matrix):
			on_satisfy()

func on_satisfy():
	active = false
	visible = false

func on_card_selected(card_display:CardDisplay):
	World.instance.current_list.erase(card_display.data)
	World.instance.cancel_selection(ViewportEffects.types.SACRIFICE)
	on_satisfy()

func on_unsated_cycle():
	time_limit -= 1
	if time_limit == 0:
		pass

func on_click():
	if type == craving_types.RES:
		try_pay()
	else:
		var _signal:Signal =World.instance.splayed_card_clicked
		if _signal.is_connected(on_card_selected): 
			#disable sacrifice mode
			_signal.disconnect(on_card_selected)
			World.instance.cancel_selection(ViewportEffects.types.SACRIFICE)
		else:
			try_pay()

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("LMB"):
		on_click()
		pass
