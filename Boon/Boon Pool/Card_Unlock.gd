extends Boon
class_name CardPackBoon

@export var cards:Array[CardData]

func apply(_god):
	for c in cards:
		Hand.card_pool.append(c)
	finished.emit()
