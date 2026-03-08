extends Node2D

@export var next_scene :String
@export var interactable :bool
@export var player_pos :Vector2
@onready var playerCharacter = $"../PlayerCharacter"
@onready var Sprite1 = $Sprite2D
@onready var Sprite2 = $Sprite2D2
@onready var InteractLabel = $RichTextLabel
@onready var SceneTransition = $"../SceneTransitionAnimation/AnimationPlayer"
var minimumDistanceFromPlayer = 35
var canInteract = false
const dialogueBalloon = preload("res://Scenes/DialogueBalloons/balloon.tscn")

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
		Sprite2.visible = !Sprite2.visible
		Signals.PlayerCanInteract.emit("button",canInteract)

func ButtonPressed(InteractableObject:String):
	if InteractableObject == "button" && interactable == true:
		sceneManager.player_pos = player_pos
		print(next_scene)
		SceneTransition.play("gradient_up")
		await SceneTransition.animation_finished
		playerCharacter.queue_free()
		# print("scene transition")
		await get_tree().create_timer(1).timeout
		sceneManager.transition_to_scene(next_scene)
