extends Sprite2D

@onready var interactButton = $"../ShuDialogue"

func _ready() -> void:
	Signals.changeDialoguePoint.connect(Callable(self,"updateDialogue"))

func updateDialogue(characterName: String, newstartingPoint: String):
	print("im doing something raaaa")
	if characterName == self.name:
		interactButton.dialogueStartingPosition = newstartingPoint
		print(newstartingPoint)
