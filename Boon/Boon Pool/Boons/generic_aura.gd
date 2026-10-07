extends Boon


@export var strategy:BaseCardStrategy


func apply(_god:God):
	_god.aura_strategies.append(strategy)
	finished.emit()
