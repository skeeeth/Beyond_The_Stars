extends Boon

func apply(_god:God):
	WinChecklist.instance.soul_fragment.check()
	var soul_fragment_sound = FmodServer.create_event_instance("event:/Soul Fragment")
	soul_fragment_sound.start()
	soul_fragment_sound.release()
	disable()
	finished.emit()
