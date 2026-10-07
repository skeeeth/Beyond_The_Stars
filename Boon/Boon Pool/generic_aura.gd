extends Boon


@export var strategy:BaseCardStrategy


func apply():
	finished.emit()
