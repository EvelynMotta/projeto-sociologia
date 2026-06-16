extends Node2D
class_name Falas

const _DIALOG_SCREEN: PackedScene = preload("res://scenes/dialog_screen.tscn")

# Aqui está a estrutura de Array corrigida! Note os colchetes [ ] abraçando as chaves { }
var _dialog_data: Array = [
	{ 
		"dialog": "ola eu odeio programar",
		"title": "vitoria"
	},
	{ 
		"dialog": "ola eu odeio o futuro",
		"title": "mais"
	},
	{ 
		"dialog": "morro de medo dele",
		"title": "vitoria"
	}
]

@export_category("objects")
@export var _hud: CanvasLayer = null

func _on_botao_iniciar_pressed() -> void:
	var _new_dialog: DialogScreen = _DIALOG_SCREEN.instantiate()
	_new_dialog.data = _dialog_data
	_hud.add_child(_new_dialog)
	# add_child já disparou _ready, então os @export estão prontos
	_new_dialog._initialize_dialog()
