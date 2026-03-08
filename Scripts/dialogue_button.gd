extends Node2D

@export var dialogueBalloon :String
@export var dialogueStartingPosition :String
@export var interactable :bool
@export var isDialogue :bool 
@onready var playerCharacter = $"../PlayerCharacter"
@onready var Sprite1 = $Sprite2D
@onready var Sprite2 = $Sprite2D2
@onready var InteractLabel = $RichTextLabel
@onready var SceneTransition = $"../SceneTransitionAnimation/AnimationPlayer"
@export var isSpiritButton:bool
var minimumDistanceFromPlayer = 35
var spiritButtonVisibilityDistance = 100
var canInteract = false
#const dialogueBalloon = preload("res://Scenes/DialogueBalloons/balloon.tscn")

func _ready() -> void:
	Signals.PlayerInteractPressed.connect(Callable(self,"ButtonPressed"))
	if isSpiritButton:
		self.visible = false
		Sprite2.modulate = Color("57e3ff")
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isSpiritButton and playerCharacter and (!playerCharacter.spiritSightOn or abs(playerCharacter.position.x - position.x) > spiritButtonVisibilityDistance):
		self.visible = false
		Sprite1.visible = true
	else:
		self.visible = true
	if !self.visible:
		return
	
	var temp = canInteract
	if playerCharacter and abs(playerCharacter.position.x - position.x) < minimumDistanceFromPlayer:
		# print("I go to %s" %next_scene)
		canInteract = true
		interactable = true
	else:
		# print("I am not interactable")
		canInteract = false
		interactable = false
	if temp != canInteract:
		Sprite2.visible = !Sprite2.visible
		Signals.PlayerCanInteract.emit("button",canInteract)

func ButtonPressed(InteractableObject:String):
	print("interact")
	if  InteractableObject == "button" && interactable == true && isDialogue == true:
		print("start dialogue")
		DialogueManager.show_dialogue_balloon_scene(load("res://Scenes/DialogueBalloons/balloon.tscn"), load("res://Assets/Dialogue/Test.dialogue"), dialogueStartingPosition, )
		return
