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
	checklist.reparent(checklist_position,false)
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
	
	match highest_favor_god:
		God.GODS.A:
			path = "res://Assets/Text Scrolls/Ganth Win.txt"
			title_line = "Ganth Ascension Ending"
		God.GODS.B:
			path = "res://Assets/Text Scrolls/Kolma Win.txt"
			title_line = "Kolma Ascension Ending"
		God.GODS.C:
			path = "res://Assets/Text Scrolls/Myggos Win.txt"
			title_line = "Myggos Ascension Ending"
		God.GODS.D:
			path = "res://Assets/Text Scrolls/Mahaux Win.txt"
			title_line = "Mahaux Ascension Ending"
	
	if god_info["Max Tier"] < 3:
		path = "res://Assets/Text Scrolls/Neutral Loss.txt"
		title_line = "Bad End"
	
	if checklist.clears_left == 0 and god_info["Min Tier"] == 3:
		path = "res://Assets/Text Scrolls/Player Win.txt"
		title_line = "True End"
		
	title_box.text = title_line
	scroll_text.set_text_from_path(path)

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Level/Game End/main_menu.tscn")
