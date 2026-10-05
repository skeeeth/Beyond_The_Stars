extends PanelContainer
class_name CardDisplay

@export var data:CardData

const SELF_SCENE = preload("uid://t05wdcm7wbwt")

static var card_size:Vector2 = Vector2(140,180) #not synced with custom_minimum_size! Change both manually

var draggable:bool = false

static func create_from_data(res:CardData) -> CardDisplay:
	var new_card:CardDisplay = SELF_SCENE.instantiate()
	new_card.data = res
	new_card.display()
	return new_card

func display():
	# Set red, blue and green values
	_set_color_value(%RedValue, str(data.absolute_scoring[RM.types.RED]))
	_set_color_value(%GreenValue, str(data.absolute_scoring[RM.types.GREEN]))
	_set_color_value(%BlueValue, str(data.absolute_scoring[RM.types.BLUE]))
	
	# Set lane specific (grey) values
	_set_color_value(%"Grey-1Value", str(data.relative_scoring[-1]))
	_set_color_value(%"Grey0Value", str(data.relative_scoring[0]))
	_set_color_value(%"Grey+1Value", str(data.relative_scoring[1]))
	
	
	#sets a label for the GREEN cost of a card, there's technology for cards to have other kinds of
	# costs but like having more symbols on the already cluttered card is dubious
	_set_color_value(%GreenCost, str(data.resource_costs[RM.types.GREEN]))
	
	#sets bottom label to favor diff with +- sign
	%"Favor Label".text = "%+d " % data.favor
	
# hide color box if value is 0, otherwise display value
func _set_color_value(label: Label, value: String):
	var int_value = int(value)
	if int_value == 0:
		var panel = label.get_parent()
		panel.self_modulate = Color.TRANSPARENT
		label.text = ""
	else:
		label.text = value

func score(in_lane:RM.types):
	
	for t in data.absolute_scoring:
		var value = data.absolute_scoring[t]
		#if value > 0: #I THINK ITS ACTUALLY BETTER TO CHECK THIS IN RM.add_resource()
		RM.add_resource(t,value)
	
	for t in data.relative_scoring:
		var value = data.relative_scoring[t]
		
		var adjusted_type = posmod((in_lane + t), (RM.types.size()))
		RM.add_resource(adjusted_type,value)
		
	RM.score_favor(in_lane, data.favor)

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
