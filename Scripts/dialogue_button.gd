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
var minimumDistanceFromPlayer = 35
var canInteract = false
#const dialogueBalloon = preload("res://Scenes/DialogueBalloons/balloon.tscn")

func _ready() -> void:
	Signals.PlayerInteractPressed.connect(Callable(self,"ButtonPressed"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
		InteractLabel.visible = !InteractLabel.visible
		Signals.PlayerCanInteract.emit("button",canInteract)

func ButtonPressed(InteractableObject:String):
	print("interact")
	if  InteractableObject == "button" && interactable == true && isDialogue == true:
		print("start dialogue")
		DialogueManager.show_dialogue_balloon_scene(load("res://Scenes/DialogueBalloons/balloon.tscn"), load("res://Assets/Dialogue/Test.dialogue"), "start", )
		return
