extends Resource
class_name QuizTheme

@export var name : String = ''
@export_group("Levels and Questions", "Levels")
@export var Easy: Array[QuizQuestion] = [] 
@export var Medium: Array[QuizQuestion] = [] 
@export var Hard: Array[QuizQuestion] = [] 
