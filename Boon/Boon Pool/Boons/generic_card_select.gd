@abstract extends Boon
class_name CardSelectBoon

@export var target_count:int = 1
var targets_left:int = target_count
@export var viewport_effect:ViewportEffects.types

func apply(_god:God):
	targets_left = target_count
	
	request_card_selections.emit(target_count)
	
	var lp_callable:Callable
	
	var limit_plays = func lp(self_callable:Callable):
		targets_left -= 1
		if targets_left == 0:
			World.instance.splayed_card_clicked.disconnect(on_card_select)
			World.instance.cancel_selection(viewport_effect)
			World.instance.splayed_card_clicked.disconnect(self_callable)
			finished.emit()
	
	lp_callable = limit_plays
	
	World.instance.splayed_card_clicked.connect(on_card_select)
	World.instance.splayed_card_clicked.connect(limit_plays.bind(lp_callable).unbind(1))

	

@abstract func on_card_select(card_display:CardDisplay)
