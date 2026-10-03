extends PanelContainer

@export var resource:CardResource



func on_score(in_lane:RM.types):
	
	for t in resource.absolute_scoring:
		var value = resource.absolute_scoring[t]
		#if value > 0: #I THINK ITS ACTUALLY BETTER TO CHECK THIS IN RM.ADD_RESOURCE
		RM.add_resource(t,value)
	
	for t in resource.relative_scoring:
		var value = resource.relative_scoring[t]
		var adjusted_type = (in_lane + t) % (RM.types.size()-1)
		RM.add_resource(adjusted_type,value)
