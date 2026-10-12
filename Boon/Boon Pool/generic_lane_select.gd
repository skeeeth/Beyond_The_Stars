@abstract extends Boon
class_name LaneSelectBoon

func apply(_god:God):
	request_lane_select.emit()
	var end_selection = func end_sel():
		World.instance.end_lane_selection()
		finished.emit()
		
	World.instance.lane_clicked.connect(on_lane_select,4)
	World.instance.lane_clicked.connect(end_selection.unbind(1),4)
	

@abstract func on_lane_select(lane:Lane)
