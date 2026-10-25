extends Control
class_name GameEnd

#var win_text:String = "You Win!"
#var lose_text:String = "You Lost"

#var win_checklist:WinChecklist
@onready var checklist_position: Node2D = $"Checklist Position"
@onready var scroll_text: TextScroll = $"Scroll Text"
@onready var title_box: Label = $"Title Box"

static var instance:GameEnd
#const OPENING = preload("res://Assets/Text Scrolls/Opening.txt")


func _ready() -> void:
	instance = self
	#display_text()

static func activate(checklist:WinChecklist):
	instance.setup(checklist)

func setup(checklist:WinChecklist):
	visible = true
	#checklist.reparent(checklist_position,false)
	#checklist.position = Vector2.ZERO
	checklist.h_box_container.visible = true
	checklist.h_box_container.reparent(checklist_position,false)
	checklist.h_box_container.position = Vector2.ZERO
	checklist.h_box_container.size.y = 0
	checklist.set_favor_tier_text()
	display_text(checklist)
	
	#if checklist.clears_left == 0:
		#display_text(win_text)
	#else:
		#display_text(lose_text)

func get_god_info() -> Dictionary:
	var highest_favor = 0
	var min_favor = 5
	var most_favored_god:God.GODS
	for key in God.god_tiers:
		var value = God.god_tiers[key]
		if highest_favor <= value:
			highest_favor = God.god_tiers[key]
			most_favored_god = key
		
		if min_favor > value:
			min_favor = value
	
	var dict = {
		"Max Tier": highest_favor,
		"Min Tier": min_favor,
		"Max God": most_favored_god
	}
	return dict

func display_text(checklist:WinChecklist):
	var path:String
	var title_line:String
	var god_info = get_god_info()
	var highest_favor_god:God.GODS =  god_info["Max God"]
	var max_tier = god_info["Max Tier"]
	var min_tier = god_info["Min Tier"]
	
	match highest_favor_god:
		God.GODS.A:
			path = "res://Assets/Text Scrolls/Ganth Win.txt"
			title_line = "Ganth Ascends"
		God.GODS.B:
			path = "res://Assets/Text Scrolls/Kolma Win.txt"
			title_line = "Kolma Ascends"
		God.GODS.C:
			path = "res://Assets/Text Scrolls/Myggos Win.txt"
			title_line = "Myggos Ascends"
		God.GODS.D:
			path = "res://Assets/Text Scrolls/Mahaux Win.txt"
			title_line = "Mahaux Ascends"
	
	if max_tier < 4:
		path = "res://Assets/Text Scrolls/Neutral Loss.txt"
		title_line = "Failed Ascension"
	
	if checklist.clears_left <= 0 and min_tier >= 4:
		path = "res://Assets/Text Scrolls/Player Win.txt"
		title_line = "True Ascension"
		
	title_box.text = title_line
	scroll_text.set_text_from_path(path)

func _on_button_pressed() -> void:
	var UI_confirm_sound = FmodServer.create_event_instance("event:/Cycle Change")
	UI_confirm_sound.start()
	UI_confirm_sound.release()
	get_tree().change_scene_to_file("res://Level/Game End/main_menu.tscn")
	
func _on_button_hover() -> void:
	var UI_hover_sound = FmodServer.create_event_instance("event:/UI Hover")
	UI_hover_sound.start()
	UI_hover_sound.release()


##debug hotkey
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		print(get_god_info())
