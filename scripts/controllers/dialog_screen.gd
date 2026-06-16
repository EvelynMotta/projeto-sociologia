extends Control
class_name DialogScreen 

var _step: float = 0.05
var _chars_per_tick: int = 1
var _id: int = 0
var _typing: bool = false
var _can_click: bool = false 
var data: Array = [] 

@export_category("objects")
@export var _name: Label = null
@export var _dialog: RichTextLabel = null

func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	_can_click = true

func _on_conti_pressend() -> void:
	if not _can_click:
		return
		
	if _typing and _dialog.visible_characters < _dialog.get_total_character_count():
		_chars_per_tick = 10
		return
		
	_chars_per_tick = 1
	_id += 1

	if _id >= data.size():
		get_tree().change_scene_to_file("res://scenes/Menu_Principal.tscn")
	else:
		_initialize_dialog()   
		
func _initialize_dialog() -> void:
	if _id >= data.size():
		return

	_name.text = data[_id]["title"]
	_dialog.text = data[_id]["dialog"]
	
	_dialog.visible_characters = 0
	_typing = true
	
	await get_tree().process_frame
	var _total_chars: int = _dialog.get_total_character_count()
	
	while _dialog.visible_characters < _total_chars:
		await get_tree().create_timer(_step).timeout
		_dialog.visible_characters += _chars_per_tick
		
	_dialog.visible_characters = _total_chars
	_typing = false


func _on_pular_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Menu_Principal.tscn")
