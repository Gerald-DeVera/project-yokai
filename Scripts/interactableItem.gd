extends Node2D

class_name interactableItem

@export var item :InvItem
@export var interactable :bool
@export var isDialogue :bool
#@export var player_pos :Vector2
@onready var playerCharacter = $"../PlayerCharacter"
@onready var Sprite1 = $Sprite2D
@onready var Sprite2 = $Sprite2D2
@onready var SceneTransition = $"../SceneTransitionAnimation/AnimationPlayer"
@onready var tooltip = $Sprite2D2/RichTextLabel
@export var isSpiritButton:bool
@export var interactText: String
@export var locked:bool 
@export var dialoguePath: String
@export var dialogueStartingPosition :String
@export var OneShot:bool

var minimumDistanceFromPlayer = 35
var canInteract = false
var spiritButtonVisibilityDistance = 100
const dialogueBalloon = preload("res://Scenes/DialogueBalloons/balloon.tscn")

func _ready() -> void:
	Signals.PlayerInteractPressed.connect(Callable(self,"ButtonPressed"))
	tooltip.text = (interactText)
	if isSpiritButton:
		self.visible = false
	if Global.oneshot_assets.has(self.name):
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isSpiritButton and playerCharacter and (!playerCharacter.spiritSightOn or abs(playerCharacter.position.x - position.x) > spiritButtonVisibilityDistance):
		self.visible = false
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
	if InteractableObject == "button" && interactable == true && isDialogue == true && locked == false:
		print("start dialogue")
		Signals.collectItem.emit(item)
		DialogueManager.show_dialogue_balloon_scene(load("res://Scenes/DialogueBalloons/balloon.tscn"), load(dialoguePath), dialogueStartingPosition, )
		if OneShot:
			Global.oneshot_assets[self.name] = true
			self.queue_free()
	elif InteractableObject == "button" && interactable == true && isDialogue == false && locked == false:
		Signals.collectItem.emit(item)
