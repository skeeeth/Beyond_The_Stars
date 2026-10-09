extends Boon


@export var strategy:BaseCardStrategy


func apply(_god:God):
	var attached_strategy = strategy.duplicate()
	_god.aura_strategies.append(attached_strategy)
	attached_strategy.applied.connect(_god.highlighter.blink.bind(Lane.strategy_pause))
	finished.emit()
