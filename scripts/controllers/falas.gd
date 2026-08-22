extends Node2D
class_name Falas

const _DIALOG_SCREEN: PackedScene = preload("res://scenes/dialog_screen.tscn")

var _dialog_data: Array = [
	{
		"dialog": "Bem-vindo a [nome da livraria]! Eu sou a Evelyn, mas pode me chamar de Elly e aquela é a Vitória.", 
		"title": "Evelyn"
	},
	{
		"dialog": "Podemos te ajudar com algo?", 
		"title": "Elly"
	},
	{
		"dialog": "Livros de sociologia? Para sua sorte acabaram de chegar alguns!", 
		"title": "Elly"
	},
	{
		"dialog": "Eles estão perto daquela bandeira vermelha. Bons estudos!", 
		"title": "Elly"
	}
]

@export_category("objects")
@export var _hud: CanvasLayer = null

func _ready() -> void:
	var _new_dialog = _DIALOG_SCREEN.instantiate()
	_new_dialog.data = _dialog_data
	_hud.add_child(_new_dialog)
	_new_dialog._initialize_dialog()
