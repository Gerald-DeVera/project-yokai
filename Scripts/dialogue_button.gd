extends Node2D

@export var dialogueBalloon :String
@export var dialogueStartingPosition :String
@export var interactable :bool
@export var isDialogue :bool 
@onready var playerCharacter = $"../PlayerCharacter"
@onready var Sprite1 = $Sprite2D
@onready var Sprite2 = $Sprite2D2
@onready var SceneTransition = $"../SceneTransitionAnimation/AnimationPlayer"
@onready var tooltip = $Sprite2D2/RichTextLabel
@export var isSpiritButton:bool
@export var interactText: String
@export var dialoguePath: String
@export var locked:bool 
var minimumDistanceFromPlayer = 35
var spiritButtonVisibilityDistance = 100
var canInteract = false
#const dialogueBalloon = preload("res://Scenes/DialogueBalloons/balloon.tscn")

func _ready() -> void:
	Signals.PlayerInteractPressed.connect(Callable(self,"ButtonPressed"))
	Signals.toggleAsset.connect(Callable(self,"toggleLock"))
	Signals.updateInteractText.connect(Callable(self,"updateTooltip"))
	tooltip.text = (interactText)
	if isSpiritButton:
		self.visible = false
		Sprite2.modulate = Color("57e3ff")
	#old redundant line for one case, might change later but doesnt really matter for this scope
	if Global.dialogueFlags.shuConfront == true && self.get_parent().name == "FlowerShop":
		self.locked = true
	if Global.locked_dialogue.has(self.name):
		self.locked = true
	elif Global.unlocked_dialogue.has(self.name):
		self.locked = false
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
	print("interact")
	if  InteractableObject == "button" && interactable == true && isDialogue == true && locked == false:
		print("start dialogue")
		DialogueManager.show_dialogue_balloon_scene(load("res://Scenes/DialogueBalloons/balloon.tscn"), load(dialoguePath), dialogueStartingPosition, )
		print
		return

func toggleLock(assetName: String, toggled: bool):
	print("signal received by:" + str(self.name))
	if assetName == self.name:
		if toggled == false:
			self.locked = true
		elif toggled == true:
			self.locked = false
			
func updateTooltip(interactName: String, newtooltip: String):
	if interactName == self.name:
		tooltip.text = newtooltip
		
