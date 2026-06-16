extends Node2D
class_name Falas

const _DIALOG_SCREEN: PackedScene = preload("res://scenes/dialog_screen.tscn")

var _dialog_data: Array = [
	{
		"dialog": "ola eu odeio programar", 
		"title": "vitoria"
	},
	{
		"dialog": "to com medo do futuro", 
		"title": "eu"
	},
	{
		"dialog": "morro de medo dele, não sei o que fazer com a minha vida", 
		"title": "vitoria"
	}
]

@export_category("objects")
@export var _hud: CanvasLayer = null

func _ready() -> void:
	var _new_dialog = _DIALOG_SCREEN.instantiate()
	_new_dialog.data = _dialog_data
	_hud.add_child(_new_dialog)
	_new_dialog._initialize_dialog()
