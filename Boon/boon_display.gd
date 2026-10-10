extends PanelContainer
class_name BoonDisplay

signal selected
signal finished

@export var boon:Boon
@export var text_box: RichTextLabel
@export var title_box:Label

@export var bg_colors:Array[Color]

var god:God

#func _ready() -> void:
	#if boon:
		#set_boon(boon)

func set_boon(b:Boon):
	boon = b
	if !boon.finished.is_connected(finished.emit):
		boon.finished.connect(finished.emit,4)
	text_box.text = (boon.description)
	#format_text(boon.description)
	title_box.text = boon.name

func format_text(_text:String):
	var extracted_stats:Array[int]
	extracted_stats = [1,0,0,0,0,1]
	
	text_box.push_table(2,INLINE_ALIGNMENT_CENTER)
	
	for i in range(0,6):
		#text_box.push_context() #breaks table for some reason?
		text_box.push_cell()
		text_box.set_cell_size_override(Vector2(64,16),Vector2(64,64))
		text_box.set_cell_border_color(Color.BLACK)
		text_box.push_bgcolor(bg_colors[i])
		text_box.append_text(str(extracted_stats[i]))
		text_box.pop()
		text_box.pop()

func hide_body():
	%RichTextLabel.hide()

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("LMB"):
		boon.apply(god)
		god.recieve_boon(boon)
		selected.emit()
		
