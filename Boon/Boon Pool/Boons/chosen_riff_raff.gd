extends Boon
##broken now that resources are all instantiated


@export var effected_cards:Array[CardData]

func apply():
	for e in effected_cards:
		for i in e.relative_scoring:
			e.relative_scoring[i] *= 5
			finished.emit()
