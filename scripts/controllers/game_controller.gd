extends Node

@export var quiz: QuizTheme
@export var color_right: Color
@export var color_wrong: Color

var buttons: Array[Button]
var index: int 
var correct: int 
var wrong: int
var unanswered: int 

# Lista temporária que receberá as perguntas da dificuldade escolhida
var questions_to_play: Array[QuizQuestion] = []

# Getter aponta para a lista selecionada
var current_quiz: QuizQuestion:
	get: return questions_to_play[index]

@onready var question_text: Label = $Content/QuestionInfo/QuestionText
@onready var timer: Timer = $Content/Timer
@onready var barra_tempo: ProgressBar = $Content/ProgressBar 

func _ready() -> void:
	# 1. Carrega o tema vindo do menu (GameManager)
	if Main.selected_quiz != null:
		quiz = Main.selected_quiz
	
	# 2. Prepara a lista baseada na dificuldade (IMPORTANTE: Nomes iguais ao seu Resource)
	_set_difficulty_list()
	
	# 3. Inicializa botões e variáveis
	correct = 0
	unanswered = 0
	
	for button in $Content/QuestionHolder.get_children():
		buttons.append(button)
		
	# Conecta o sinal do tempo esgotado via código (caso não tenha conectado pelo editor)
	if not timer.timeout.is_connected(_on_timer_timeout):
		timer.timeout.connect(_on_timer_timeout)
		
	load_quiz()
	
# Atualiza a barra visualmente a cada quadro enquanto o timer roda
func _process(_delta: float) -> void:
	if timer and not timer.is_stopped():
		barra_tempo.value = timer.time_left
		
func _set_difficulty_list() -> void:
	# O match deve bater com o que você salvar no GameManager (ex: "facil", "medio", "dificil")
	match Main.level:
		"facil":
			questions_to_play = quiz.Easy.duplicate()
		"medio":
			questions_to_play = quiz.Medium.duplicate()
		"dificil":
			questions_to_play = quiz.Hard.duplicate()
		_:
			# Fallback caso a variável esteja vazia ou escrita errada
			questions_to_play = quiz.Easy.duplicate()
	
	# Embaralha as perguntas da dificuldade escolhida
	questions_to_play.shuffle()

func load_quiz() -> void:
	# Verifica se o jogo acabou baseado na lista de dificuldade
	if index >= questions_to_play.size():
		_game_over()
		return
		
	question_text.text = current_quiz.question_info

	# Embaralha opções sem alterar o Resource original
	var options = current_quiz.options.duplicate()
	options.shuffle()
	
	for i in buttons.size():
		# Desconecta sinais antigos para evitar acumular conexões
		if buttons[i].pressed.is_connected(_buttons_answer):
			buttons[i].pressed.disconnect(_buttons_answer)
			
		buttons[i].text = options[i]
		buttons[i].pressed.connect(_buttons_answer.bind(buttons[i]))

# --- INICIA O TIMER PARA A NOVA PERGUNTA ---
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
		
	# Trava interação para evitar cliques duplos durante o delay
	for btn in buttons: btn.disabled = true
	
	await get_tree().create_timer(1.0).timeout
	
	for btn in buttons: btn.disabled = false
	_next_question()
	
	# --- FUNÇÃO EXECUTADA QUANDO O TEMPO ACABA ---
func _on_timer_timeout() -> void:
	unanswered += 1
	# Trava os botões
	for btn in buttons: 
		btn.disabled = true
		# Destaca em vermelho a opção errada por falta de tempo
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
	# Placar baseado no total da dificuldade escolhida
	$Content/GameOver/Correct.text = "Acertos:" + str(correct, "/", questions_to_play.size())
	$Content/GameOver/Wrong.text = "Erros: " + str(wrong) + "/" + str(questions_to_play.size())
	$Content/GameOver/Unanswered.text = "Não respondidas a tempo: " + str(unanswered, "/", questions_to_play.size())
	
func _on_button_pressed() -> void:
	get_tree().reload_current_scene()

func _on_buttonm_mnp_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Menu_Principal.tscn")
