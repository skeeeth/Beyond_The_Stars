extends LaneSelectBoon

@export var card:CardData
@export var count:int

func on_lane_select(lane:Lane):
	for i in range(0,count):
		lane.add_card(card.duplicate())
