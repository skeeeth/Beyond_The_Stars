extends Boon

func apply(_god:God):
	WinChecklist.instance.soul_fragment.check()
	disable()
	finished.emit()
