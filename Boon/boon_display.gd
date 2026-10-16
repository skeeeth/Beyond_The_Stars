extends PanelContainer
class_name BoonDisplay

signal selected
signal finished

signal card_selection_requested(count:int)
signal lane_selection_requested

@export var boon:Boon
@export var text_box: RichTextLabel
@export var title_box:Label
@export var card_container:Container


@export var color_export:Array[Color]
static var bg_colors:Array[Color]
var god:God

func _ready() -> void:
	bg_colors = color_export
	#if boon:
		#set_boon(boon)

func set_boon(b:Boon):
	boon = b
	if !boon.finished.is_connected(finished.emit):
		boon.finished.connect(finished.emit,4)
	
	if !boon.request_card_selections.is_connected(card_selection_requested.emit):
		boon.request_card_selections.connect(card_selection_requested.emit, 4)
	
	if !boon.request_lane_select.is_connected(lane_selection_requested.emit):
		boon.request_lane_select.connect(lane_selection_requested.emit, 4)
	
	text_box.text = ""#(boon.description)
	format_text(boon.description,text_box)
	title_box.text = boon.name
	
	if boon is CardPackBoon:
		display_cards(boon.cards)

static func format_text(text:String, rich_text_box:RichTextLabel):
	var start = text.find("[[")
	#var end = text.find("]]")
	if start == -1:
		rich_text_box.append_text(text)
		return
	rich_text_box.append_text(text.left(start))
	var stat_block = text.substr(start+2, 11)
	#print(stat_block)
	var extracted_stats:Array[int] = [0,0,0,0,0,0]
	var stat_order:Array[int] = [0,2,4,1,3,5]
	var order_index:int = 0
	
	for character_index in range(0,12,2):
		var char_ = stat_block.substr(character_index,1)#wait this breaks with 2 digit numbers lol
		var num = int(char_)
		extracted_stats[stat_order[order_index]] = num
		order_index += 1
	 
	#extracted_stats = [1,0,0,0,0,1]
	
	rich_text_box.push_table(2,INLINE_ALIGNMENT_CENTER)
	
	for i in range(0,6):
		#text_box.push_context() #breaks table for some reason?
		rich_text_box.push_cell()
		rich_text_box.set_cell_size_override(Vector2(64,16),Vector2(64,64))
		rich_text_box.set_cell_border_color(Color.BLACK)
		rich_text_box.push_bgcolor(bg_colors[i])
		if extracted_stats[i] > 0:
			rich_text_box.append_text(str(extracted_stats[i]))
		else:
			rich_text_box.append_text(" ")
		rich_text_box.pop()
		rich_text_box.pop()
	rich_text_box.pop()
	
	var remaining_text = text.substr(start+13)
	rich_text_box.append_text(remaining_text)

func hide_body():
	%RichTextLabel.hide()
	card_container.hide()

func display_cards(cards:Array[CardData]):
	for card in cards:
		var new_card = CardDisplay.create_from_data(card)
		new_card.scale = Vector2(0.4,0.4)
		card_container.add_child(new_card)


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("LMB"):
		boon.apply(god)
		god.recieve_boon(boon)
		selected.emit()
		#play boon selection sound
		var boon_select_sound = FmodServer.create_event_instance("event:/UI Confirm (Big)")
		boon_select_sound.start()
		boon_select_sound.release()


func _play_boon_hover() -> void:
	var boon_hover_sound = FmodServer.create_event_instance("event:/UI Hover")
	boon_hover_sound.start()
	boon_hover_sound.release()
