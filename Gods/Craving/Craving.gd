extends PanelContainer
class_name Craving

signal craving_failed

enum craving_types{RES, LANE, HAND}
var type:craving_types

@export var card_odds_per_tier:Array[float]
@onready var rich_text_label: RichTextLabel = $RichTextLabel
@onready var time_limit_label: Label = $"Time Limit"

var resource_matrix:Dictionary[RM.types,int] = {
	RM.types.RED: 0,
	RM.types.GREEN: 0,
	RM.types.BLUE: 0,
}

var active:bool = false
var time_limit:int = 2:
	set(v):
		time_limit = v
		time_limit_label.text = "Cycles left: %s" % time_limit
	get:
		return time_limit

func set_craving(tier:int):
	active = true
	visible = true
	var card_odds:float = card_odds_per_tier[tier]
	
	
	if randf() > card_odds:
		set_resource_craving(tier)
	else:
		set_card_craving(tier)

func set_resource_craving(tier:int):
	time_limit = 2
	type = craving_types.RES
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
	time_limit = 2
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
		#play sacrifice audio
	var sacrifice_sound = FmodServer.create_event_instance("event:/Card Discard")
	sacrifice_sound.start()
	sacrifice_sound.release()
	on_satisfy()

func on_unsated_cycle():
	time_limit -= 1
	if time_limit == 0:
		craving_failed.emit()
		visible = false
		active = false

func on_click():
	var _initiate_sacrifice = FmodServer.create_event_instance("event:/Initiate Sacrifice")
	_initiate_sacrifice.start()
	_initiate_sacrifice.release()
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
		
func _card_hover_sound() -> void:
	var _card_hover = FmodServer.create_event_instance("event:/UI Hover")
	_card_hover.start()
	_card_hover.release()
