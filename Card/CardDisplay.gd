extends PanelContainer
class_name CardDisplay

signal clicked(who:CardDisplay)

@export var data:CardData

const SELF_SCENE = preload("uid://t05wdcm7wbwt")

static var card_size:Vector2 = Vector2(188,200) #not synced with custom_minimum_size! Change both manually

var draggable:bool = false
var last_color_stat_snapshot:Dictionary
var last_grey_stat_snapshot:Dictionary

static func create_from_data(res:CardData) -> CardDisplay:
	var new_card:CardDisplay = SELF_SCENE.instantiate()
	new_card.data = res
	new_card.last_color_stat_snapshot = res.get_adjusted_abs_values()
	new_card.last_grey_stat_snapshot = res.get_adjusted_rel_values()
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
	
	#sets bottom label to favor diff with +- sign
	%"Favor Label".text = "%+d " % data.favor
	
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
		var grow = self.create_tween()
		var starting_size:int = label.label_settings.outline_size
		grow.tween_property(label.label_settings,"outline_size",starting_size + 3, 0)
		grow.tween_interval(Lane.strategy_pause)
		grow.tween_property(label.label_settings,"outline_size",starting_size, 0)


##maps which indexes are different, not the actual difference
func _get_stat_differences(prev:Dictionary,current:Dictionary) -> Array[bool]:
	assert(prev.size() == current.size())
	var diff: Array[bool]
	for key in current:
		diff.append(prev[key] == current[key])
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
		
	RM.score_favor(in_lane, data.favor)
	data.reset_temp_values()

#does it ever feel like your cursor is pregnant with information
func _get_drag_data(_at_position: Vector2) -> Variant:
	if !draggable:
		return
	
	var drag_data:Dictionary = {
		"RES" = data,
		"source" = self
	}
	
	var preview = CardDisplay.create_from_data(data)
	set_drag_preview(preview)
	
	return drag_data


func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("LMB"):
		clicked.emit(self)
