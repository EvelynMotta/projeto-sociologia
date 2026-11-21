extends Node

@export var quiz: QuizTheme
@export var color_right: Color
@export var color_wrong: Color

var buttons: Array[Button]
var index: int 
var correct: int 
var wrong: int
var unanswered: int 

var questions_to_play: Array[QuizQuestion] = []

var current_quiz: QuizQuestion:
	get: return questions_to_play[index]

@onready var question_text: Label = $Content/QuestionInfo/QuestionText
@onready var timer: Timer = $Content/Timer
@onready var barra_tempo: ProgressBar = $Content/ProgressBar 

func _ready() -> void:

	if Main.selected_quiz != null:
		quiz = Main.selected_quiz
	

	_set_difficulty_list()
	

	correct = 0
	unanswered = 0
	
	for button in $Content/QuestionHolder.get_children():
		buttons.append(button)
		

	if not timer.timeout.is_connected(_on_timer_timeout):
		timer.timeout.connect(_on_timer_timeout)
		
	load_quiz()
	

func _process(_delta: float) -> void:
	if timer and not timer.is_stopped():
		barra_tempo.value = timer.time_left
		
func _set_difficulty_list() -> void:
	
	match Main.level:
		"facil":
			questions_to_play = quiz.Easy.duplicate()
		"medio":
			questions_to_play = quiz.Medium.duplicate()
		"dificil":
			questions_to_play = quiz.Hard.duplicate()
		_:

			questions_to_play = quiz.Easy.duplicate()
	

	questions_to_play.shuffle()

func load_quiz() -> void:

	if index >= questions_to_play.size():
		_game_over()
		return
		
	question_text.text = current_quiz.question_info


	var options = current_quiz.options.duplicate()
	options.shuffle()
	
	for i in buttons.size():
		
		if buttons[i].pressed.is_connected(_buttons_answer):
			buttons[i].pressed.disconnect(_buttons_answer)
			
		buttons[i].text = options[i]
		buttons[i].pressed.connect(_buttons_answer.bind(buttons[i]))


	barra_tempo.max_value = timer.wait_time
	barra_tempo.value = timer.wait_time
	timer.start()
				
func _buttons_answer(button: Button) -> void:
	if current_quiz.correct == button.text:
		button.modulate = color_right
		correct += 1
	else:
		button.modulate = color_wrong
		wrong += 1
		
	
	for btn in buttons: btn.disabled = true
	
	await get_tree().create_timer(1.0).timeout
	
	for btn in buttons: btn.disabled = false
	_next_question()
	

func _on_timer_timeout() -> void:
	unanswered += 1
	# Trava os botões
	for btn in buttons: 
		btn.disabled = true
	
		btn.modulate = color_wrong 
		
	await get_tree().create_timer(1.0).timeout
	
	for btn in buttons: btn.disabled = false
	_next_question()
	
func _next_question() -> void:
	for bt in buttons:
		bt.modulate = Color.WHITE
		
	index += 1
	load_quiz()

func _game_over() -> void:
	timer.stop()
	$Content/GameOver.show()
	
	$Content/GameOver/Correct.text = "Acertos:" + str(correct, "/", questions_to_play.size())
	$Content/GameOver/Wrong.text = "Erros: " + str(wrong) + "/" + str(questions_to_play.size())
	$Content/GameOver/Unanswered.text = "Não respondidas a tempo: " + str(unanswered, "/", questions_to_play.size())
	
func _on_button_pressed() -> void:
	get_tree().reload_current_scene()

func _on_buttonm_mnp_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Menu_Principal.tscn")
