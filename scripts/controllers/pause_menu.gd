extends Control

func _ready():
	$AnimationPlayer.play("blur")
	
func resume():
	get_tree().paused = false 
	hide()
	$AnimationPlayer.play_backwards("RESET")
	
func pause():
	get_tree().paused = true
	show()
	$AnimationPlayer.play("RESET")
	
func _on_button_pause_pressed():
	if get_tree().paused == false:
		pause()
	elif get_tree().paused == true:
		resume()

func _on_button_resume_pressed() -> void:
	resume()

func _on_button_restart_pressed() -> void:
	resume()
	get_tree().reload_current_scene()

func _on_button_quit_pressed() -> void:
	get_tree().quit()

func _on_button_back_pressed() -> void:
	resume() 
	get_tree().change_scene_to_file("res://scenes/Menu_Principal.tscn")
