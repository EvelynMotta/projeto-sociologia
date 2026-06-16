extends Control
class_name DialogScreen 

var _step: float = 0.05
var _chars_per_tick: int = 1
var _id: int = 0
var _typing: bool = false
var data: Array = [] # Configurado para receber a Array perfeitamente
@export_category("objects")
@export var _name: Label = null
@export var _dialog: RichTextLabel = null

func _ready() -> void:
	pass

func _on_conti_pressend() -> void:
	# Se ainda está digitando, o clique acelera
	if _typing and _dialog.visible_ratio < 1.0:
		_chars_per_tick = 5
		return
		
	# Já terminou de aparecer: passa para a próxima fala
	_chars_per_tick = 1
	_id += 1

	if _id >= data.size():
		get_tree().change_scene_to_file("res://scenes/Menu_Principal.tscn")
	else:
		_initialize_dialog()   
		
func _initialize_dialog() -> void:
	if _id >= data.size():
		return
	print("ID:", _id)
	print("DATA:", data)
	print("SIZE:", data.size())

	_name.text = data[_id]["title"]
	_dialog.text = data[_id]["dialog"]
		# Reset essencial: sem isto, visible_characters = -1 (mostra tudo) e o while nunca roda
	_dialog.visible_characters = 0
	
	_typing = true
	while _dialog.visible_ratio < 1.0:
		await get_tree().create_timer(_step).timeout
		_dialog.visible_characters += _chars_per_tick
	_typing = false
