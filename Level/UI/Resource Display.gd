extends Control

@export var type:RM.types
@onready var label: Label = $HBoxContainer/Label
@onready var icon: TextureRect = $HBoxContainer/Icon

@export var panel_variations:Dictionary[RM.types,StyleBox]

func _ready() -> void:
	RM.resource_added.connect(on_update.bind(true))
	RM.resource_spend.connect(on_update.bind(false))
	label.text = RM.names[type] + str(RM.current[type])
	icon.texture = RM.resource_icons[type]
	on_update(type,0,true)

func on_update(t,change:int,is_add:bool):
	if t != type: return #dont do anything for other types

	#label.text = RM.names[type] + ": %s (%s)" % [RM.current[type], RM.cumulative[type]]
	#label.text = ": %s (%s)" % [RM.current[type], RM.cumulative[type]]
	label.text = ": %s" % RM.current[type]
	
	if change == 0: return
	if !is_add:
		change *= -1
	#create change text
	var fade_text = Label.new()
	fade_text.text = "%+d" % change
	fade_text.label_settings = label.label_settings
	label.add_child(fade_text)
	fade_text.global_position = label.global_position + Vector2(0,60)
	
	#rise and fade text
	var fade_duration:float = 0.5
	var change_display = create_tween()
	change_display.tween_property(fade_text,"modulate",Color(Color.WHITE,0),fade_duration)
	change_display.parallel().tween_property(fade_text,
			"global_position",label.global_position,fade_duration)
	change_display.tween_callback(fade_text.queue_free)
