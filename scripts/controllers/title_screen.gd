extends Control


func _on_button_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/falas.tscn")


func _on_button_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/credits.tscn")


func _on_button_quit_game_pressed() -> void:
	get_tree().quit()
