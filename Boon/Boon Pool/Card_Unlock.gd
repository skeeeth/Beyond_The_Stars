extends Boon

@export var cards:Array[CardData]

func apply():
	for c in cards:
		Hand.card_pool.append(c)
	finished.emit()
