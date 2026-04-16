extends Control

func _on_button_weber_pressed():
	Main.selected_quiz = load("res://resources/varied/themes/theme_Weber.tres")
	get_tree().change_scene_to_file("res://scenes/Level_Menu.tscn")
	
func _on_button_marx_pressed():
	Main.selected_quiz = load("res://resources/varied/themes/theme_Marx.tres")
	get_tree().change_scene_to_file("res://scenes/Level_Menu.tscn")

func _on_button_durkheim_pressed():
	Main.selected_quiz = load("res://resources/varied/themes/theme_Durkheim.tres")
	get_tree().change_scene_to_file("res://scenes/Level_Menu.tscn")
	
func _on_button_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Title_Screen.tscn")
