extends Boon



func apply(_god):
	ActionManager.actions_per_cycle += 1
	finished.emit()
