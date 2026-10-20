extends RichTextLabel
class_name TextScroll

#var character_index = 0

func start() -> Signal:
	var scroll_tween = self.create_tween()
	visible_characters = 1
	for c in text:
		var delay:float
		match c:
			"\n":
				delay = 0.1
			".":
				delay = 0.5
			_:
				delay = 2.0/60.0
		scroll_tween.tween_callback(reveal_character)
		scroll_tween.tween_interval(delay)

	return scroll_tween.finished

func reveal_character():
	#character_index += 1
	visible_characters += 1
	#return text.substr(character_index,1)

func set_text_from_path(path:String) -> Signal:
	text = read_text_file(path)
	return start() 

func read_text_file(path: String) -> String:
	# Check if the file exists before attempting to open it
	if not FileAccess.file_exists(path):
		print("File does not exist: ", path)
		return ""
	
	# Open the file with READ permissions
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		print("Failed to open file. Error code: ", FileAccess.get_open_error())
		return ""
	
	# Read the text contents and automatically clear memory
	var content = file.get_as_text()
	return content
