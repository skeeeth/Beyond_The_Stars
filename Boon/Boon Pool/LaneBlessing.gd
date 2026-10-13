extends LaneSelectBoon

@export var strategy:BaseCardStrategy

func on_lane_select(lane:Lane):
	lane.lane_strategies.append(strategy)
