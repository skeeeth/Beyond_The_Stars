extends Button
class_name WinChecklist

static var instance:WinChecklist #give reference

@onready var list_items:Array[WinListItem] = [%"Cult Size", %"Soul Fragment", %"Great Feast"]

@export var target_cult_size:int = 30
@export var feast_cost:int = 25
@export var sacrifices:int = 2
@onready var cult_size: WinListItem = %"Cult Size"
@onready var soul_fragment: WinListItem = %"Soul Fragment"
@onready var great_feast: WinListItem = %"Great Feast"
@onready var checklist_panel: PanelContainer = $"HBoxContainer/Checklist Panel"
@onready var h_box_container: VBoxContainer = $HBoxContainer

@onready var spacer: Control = $HBoxContainer/Spacer


var clears_left:int

func _ready() -> void:
	spacer.custom_minimum_size = size
	RM.resource_added.connect(on_cultist_generated)
	WinChecklist.instance = self
	for item in list_items:
		item.cleared.connect(on_win_condition_cleared)
	
	great_feast.button.text = "Begin Feast (%s food, %s sacrifices)" % [feast_cost, sacrifices]
	clears_left = list_items.size()
	on_cultist_generated(RM.types.BLUE,0)

func on_win_condition_cleared():
	clears_left -= 1

func on_cultist_generated(resource_type:RM.types, _amount:int):
	if resource_type!= RM.types.BLUE:
		return
	
	cult_size.label.text = "Total members: %s/%s" % [RM.cumulative[RM.types.BLUE], target_cult_size]
	if RM.cumulative[RM.types.BLUE] > target_cult_size:
		cult_size.check()

func _on_great_feast_button_pressed() -> void:
	if RM.try_spend(RM.types.GREEN,feast_cost):
		start_feast()
	pass # Replace with function body.

#region Mr Feast
##this code is mostly copy pasted from Craving.gd instead of being properly abstracted
## which makes me want to vomit but fuck it we ballll
func start_feast():
	var _initiate_sacrifice = FmodServer.create_event_instance("event:/Initiate Sacrifice")
	_initiate_sacrifice.start()
	_initiate_sacrifice.release()
	World.instance.request_lane_card_selection(ViewportEffects.types.SACRIFICE)
	#World.instance.viewport_effects.apply_type(ViewportEffects.types.SACRIFICE)
	World.instance.splayed_card_clicked.connect(on_sacrifice_selected)

func on_sacrifice_selected(card_display:CardDisplay):
	World.instance.current_list.erase(card_display.data)
		#play sacrifice audio
	var sacrifice_sound = FmodServer.create_event_instance("event:/Card Discard")
	sacrifice_sound.start()
	sacrifice_sound.release()
	
	sacrifices -= 1
	if sacrifices == 0:
		#end feast
		World.instance.cancel_selection(ViewportEffects.types.SACRIFICE)
		World.instance.splayed_card_clicked.disconnect(on_sacrifice_selected)
		great_feast.check()
		great_feast.button.queue_free()

#endregion

func _on_pressed() -> void:
	h_box_container.visible = !h_box_container.visible
