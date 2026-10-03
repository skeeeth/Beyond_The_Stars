extends PanelContainer
class_name CardDisplay

@export var data:CardData

const SELF_SCENE = preload("uid://t05wdcm7wbwt")

static var card_size:Vector2 = Vector2(140,180) #not synced with custom_minimum_size! Change both manually

static func create_from_data(res:CardData) -> CardDisplay:
	var new_card:CardDisplay = SELF_SCENE.instantiate()
	new_card.data = res
	new_card.display()
	return new_card

func display():
	%RedValue.text = str(data.absolute_scoring[RM.types.RED])
	%GreenValue.text = str(data.absolute_scoring[RM.types.GREEN])
	%BlueValue.text = str(data.absolute_scoring[RM.types.BLUE])
	
	%"Grey-1Value".text = str(data.relative_scoring[-1])
	%Grey0Value.text = str(data.relative_scoring[0])
	%"Grey+1Value".text = str(data.relative_scoring[1])


func score(in_lane:RM.types):
	
	for t in data.absolute_scoring:
		var value = data.absolute_scoring[t]
		#if value > 0: #I THINK ITS ACTUALLY BETTER TO CHECK THIS IN RM.add_resource()
		RM.add_resource(t,value)
	
	for t in data.relative_scoring:
		var value = data.relative_scoring[t]
		
		var adjusted_type = posmod((in_lane + t), (RM.types.size()))
		RM.add_resource(adjusted_type,value)
