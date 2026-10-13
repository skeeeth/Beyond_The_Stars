extends PanelContainer
class_name Tooltip

@export var keyword:Keyword

@export var word_label:Label
@export var body_label:RichTextLabel

const _self_scene = preload("res://Card/Tooltip/tooltip.tscn")

static func create(k:Keyword) -> Tooltip:
	var new_tt:Tooltip = _self_scene.instantiate()
	new_tt.word_label.text = k.word
	new_tt.body_label.text = ""
	new_tt.body_label.push_font_size(18)
	BoonDisplay.format_text(k.description, new_tt.body_label)
	
	return new_tt
