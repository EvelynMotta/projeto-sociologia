extends Control


func _on_button_easy_pressed() -> void:
	Main.level = "facil"
	get_tree().change_scene_to_file("res://scenes/Quiz.tscn")


func _on_button_medium_pressed() -> void:
	Main.level = "medio"
	get_tree().change_scene_to_file("res://scenes/Quiz.tscn")


func _on_button_hard_pressed() -> void:
	Main.level = "dificil"
	get_tree().change_scene_to_file("res://scenes/Quiz.tscn")


func _on_button_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Menu_Principal.tscn")
