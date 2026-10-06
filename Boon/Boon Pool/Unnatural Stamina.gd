extends Boon



func apply():
	ActionManager.actions_per_cycle += 1
	finished.emit()
