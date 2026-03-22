extends Node2D

class_name button

@export var next_scene :String
@export var interactable :bool
@export var player_pos :Vector2
@onready var playerCharacter = $"../PlayerCharacter"
@onready var Sprite1 = $Sprite2D
@onready var Sprite2 = $Sprite2D2
@onready var SceneTransition = $"../SceneTransitionAnimation/AnimationPlayer"
@export var isSpiritButton:bool
@onready var tooltip = $Sprite2D2/RichTextLabel
@export var interactText: String
@export var locked:bool 

var minimumDistanceFromPlayer = 35
var canInteract = false
var spiritButtonVisibilityDistance = 100
const dialogueBalloon = preload("res://Scenes/DialogueBalloons/balloon.tscn")

func _ready() -> void:
	Signals.PlayerInteractPressed.connect(Callable(self,"ButtonPressed"))
	Signals.toggleArea.connect(Callable(self,"ToggleLock"))
	tooltip.text = (interactText)
	if isSpiritButton:
		self.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isSpiritButton and playerCharacter and (!playerCharacter.spiritSightOn or abs(playerCharacter.position.x - position.x) > spiritButtonVisibilityDistance):
		self.visible = false
	else:
		self.visible = true
	if !self.visible:
		return
	
	var temp = canInteract
	if playerCharacter and abs(playerCharacter.position.x - position.x) < minimumDistanceFromPlayer and locked == false:
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

func ToggleLock(areaName: String, toggled: bool):
	if areaName == self.name:
		if toggled == true:
			self.locked = false
		elif toggled == false:
			self.locked = true
