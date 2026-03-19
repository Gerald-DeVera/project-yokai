extends Resource

class_name QuestItem

@export var questName: String
@export var completionStatus: bool
@export var fullDescription: String

func _init(QN = "", c = false, fd = ""):
	questName = QN
	completionStatus = c
	fullDescription = fd
