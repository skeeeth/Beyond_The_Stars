extends PanelContainer
class_name CardDisplay

signal clicked(who:CardDisplay)
signal removal_requested(who:CardDisplay)

@export var data:CardData

const SELF_SCENE = preload("uid://t05wdcm7wbwt")

static var card_size:Vector2 = Vector2(188,200) #not synced with custom_minimum_size! Change both manually

var draggable:bool = false
var last_color_stat_snapshot:Dictionary
var last_grey_stat_snapshot:Dictionary
var last_favor:float
var tooltips:Array[Tooltip]
var card_deal_sound# = FmodServer.create_event_instance("event:/Card Deal")
@onready var tooltip_position: Node2D = $"Tooltip Position"
var being_dragged:bool = false

func _ready() -> void:
	card_deal_sound = FmodServer.create_event_instance("event:/Card Deal")

static func create_from_data(res:CardData) -> CardDisplay:
	var new_card:CardDisplay = SELF_SCENE.instantiate()
	new_card.data = res
	new_card.last_color_stat_snapshot = res.get_adjusted_abs_values()
	new_card.last_grey_stat_snapshot = res.get_adjusted_rel_values()
	new_card.last_favor = res.get_adjusted_favor()
	for k in res.keywords:
		k.strategy.applied.connect(new_card.blink_textbox)
	new_card.display()
	return new_card



func display():
	#show the cards name
	%"Card Name".text = data.card_name
	
	# Set red, blue and green values
	var adj_abs_values = data.get_adjusted_abs_values()
	var abs_changes = _get_stat_differences(last_color_stat_snapshot,adj_abs_values)
	_set_color_value(%RedValue, str(adj_abs_values[RM.types.RED]), abs_changes[0])
	_set_color_value(%GreenValue, str(adj_abs_values[RM.types.GREEN]), abs_changes[0])
	_set_color_value(%BlueValue, str(adj_abs_values[RM.types.BLUE]), abs_changes[0])
	
	last_color_stat_snapshot = adj_abs_values
	
	# Set lane specific (grey) values
	var adj_rel_values = data.get_adjusted_rel_values()
	var rel_changes = _get_stat_differences(last_grey_stat_snapshot,adj_rel_values)
	_set_color_value(%"Grey-1Value", str(adj_rel_values[-1]), rel_changes[0])
	_set_color_value(%"Grey0Value", str(adj_rel_values[0]), rel_changes[1])
	_set_color_value(%"Grey+1Value", str(adj_rel_values[1]), rel_changes[2])
	
	last_grey_stat_snapshot = adj_rel_values
	
	#sets a label for the GREEN cost of a card, there's technology for cards to have other kinds of
	# costs but like having more symbols on the already cluttered card is dubious
	_set_color_value(%GreenCost, str(data.resource_costs[RM.types.GREEN]))
	
	#play a sound if stats have changed
	abs_changes.append_array(rel_changes) #combined changes
	if abs_changes.has(true):
		#call stat change sound...
		var stat_increase_sound = FmodServer.create_event_instance("event:/Stat Increase")
		stat_increase_sound.start()
		stat_increase_sound.release()
		pass
	
	
	#write keywords
	var text:String = ""
	for keyword in data.keywords:
		text += keyword.word + "\n"
	%Description.text = text
	
	#sets bottom label to favor diff with +- sign
	%"Favor Label".text = "%+d " % data.get_adjusted_favor()
	if last_favor != data.get_adjusted_favor():
		_grow_label(%"Favor Label")
	last_favor = data.get_adjusted_favor()
	
func _grow_label(label:Label):
	var grow = self.create_tween()
	var starting_size:int = label.label_settings.outline_size
	grow.tween_property(label.label_settings,"outline_size",starting_size + 8, 0)
	grow.tween_interval(Lane.strategy_pause)
	grow.tween_property(label.label_settings,"outline_size",starting_size, 0)

# hide color box if value is 0, otherwise display value
func _set_color_value(label: Label, value: String, changed:bool = false):
	var int_value = int(value)
	var panel = label.get_parent()
	if int_value == 0:
		panel.self_modulate = Color.TRANSPARENT
		label.text = ""
	else:
		panel.self_modulate = Color.WHITE
		label.text = value
	
	if changed:
		_grow_label(label)


##maps which indexes are different, not the actual difference
func _get_stat_differences(prev:Dictionary,current:Dictionary) -> Array[bool]:
	assert(prev.size() == current.size())
	var diff: Array[bool]
	for key in current:
		diff.append(prev[key] != current[key])
	return diff

func score(in_lane:RM.types):
	
	for t in data.absolute_scoring:
		var value = data.get_adjusted_abs_values()[t]
		#value += data.temp_color_mod[t]
		#if value > 0: #I THINK ITS ACTUALLY BETTER TO CHECK THIS IN RM.add_resource()
		RM.add_resource(t,value)
	
	for t in data.relative_scoring:
		var value = data.get_adjusted_rel_values()[t]
		value += data.temp_grey_mod[t]
		var adjusted_type = posmod((in_lane + t), (RM.types.size()))
		RM.add_resource(adjusted_type,value)
		
	RM.score_favor(in_lane, data.get_adjusted_favor())

func request_removal():
	removal_requested.emit(self)
	#print(removal_requested.get_connections())
	#print(" ")

func be_eaten():
	var eat = self.create_tween()
	var eat_duration:float = 0.2
	eat.tween_property(self,"scale:y",0,eat_duration)
	eat.parallel().tween_property(self,"position:y",position.y + (size.y/2.0),eat_duration)
	eat.tween_callback(queue_free)

const BASE_TEXT_STYLE_BOX = preload("uid://cm2738lmkufw5")
const HIGHLIGHT_STYLE_BOX = preload("uid://fujdbjtsa2ew")

func blink_textbox():
	var box:PanelContainer = %Description.get_parent()
	var tween = create_tween().bind_node(self)
	tween.tween_callback(box.add_theme_stylebox_override.bind("panel", HIGHLIGHT_STYLE_BOX))
	#box.remove_theme_stylebox_override("panel")
	#box.add_theme_stylebox_override("panel", HIGHLIGHT_STYLE_BOX)

	tween.tween_interval(Lane.strategy_pause)
	tween.tween_callback(box.add_theme_stylebox_override.bind("panel", BASE_TEXT_STYLE_BOX))
	


#does it ever feel like your cursor is pregnant with information
func _get_drag_data(_at_position: Vector2) -> Variant:
	if !draggable:
		return
	
	#being dragged feedback
	visible = false
	being_dragged = true
	_card_grab_sound()
	
	#set drag data
	var drag_data:Dictionary = {
		"RES" = data,
		"source" = self
	}
	
	#set preview with offset
	var preview = CardDisplay.create_from_data(data)
	var drag_center = Control.new()
	drag_center.add_child(preview)
	set_drag_preview(drag_center)
	preview.position -= get_local_mouse_position()
	
	return drag_data

func _input(event: InputEvent) -> void:
	if event.is_action_released("LMB"):
		#card_deal_sound.start()
		#card_deal_sound.release()
		if being_dragged:
			_card_grab_sound() #or release sound, if different
			visible = true
			being_dragged = false

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("LMB"):
		clicked.emit(self)
		


func _on_mouse_entered() -> void:
	var _card_hover = FmodServer.create_event_instance("event:/UI Hover")
	_card_hover.start()
	_card_hover.release()
	
	for k in data.keywords:
		var new_tt:Tooltip = Tooltip.create(k)
		new_tt.position.y = tooltips.size() * 80
		tooltip_position.add_child(new_tt)
		tooltips.append(new_tt)
		

func _on_mouse_exited() -> void:
	for tt in tooltips:
		tt.queue_free()
	tooltips.clear()
	pass # Replace with function body.
	
func _card_grab_sound() -> void:
	if draggable:
		card_deal_sound = FmodServer.create_event_instance("event:/Card Deal")
		card_deal_sound.start()
		card_deal_sound.release()
