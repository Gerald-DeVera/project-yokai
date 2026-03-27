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
var turnedVisible = false
const dialogueBalloon = preload("res://Scenes/DialogueBalloons/balloon.tscn")

func _ready() -> void:
	Signals.PlayerInteractPressed.connect(Callable(self,"ButtonPressed"))
	Signals.toggleArea.connect(Callable(self,"ToggleLock"))
	DialogueManager.dialogue_started.connect(Callable(self,"disableVis"))
	tooltip.text = (interactText)
	if isSpiritButton:
		self.visible = false
	if self.name == "AlleyDoor" && Global.dialogueFlags.interviewedShu == true:
		locked = false	
	#update when portal flag integrated
	if self.name == "YokaiPortal" && Global.dialogueFlags.shuConfront == true && Global.dialogueFlags.spiritRealmUnlocked == false:
		locked = false	
	elif self.name == "YokaiPortal" && Global.dialogueFlags.shuConfront == true && Global.dialogueFlags.spiritRealmUnlocked == true:
		locked = false	
		self.visible = true
		self.interactText = str("Yokai Realm")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isSpiritButton and !turnedVisible and playerCharacter and abs(playerCharacter.position.x - position.x) > spiritButtonVisibilityDistance or locked == true:
		self.visible = false
	elif isSpiritButton and turnedVisible and playerCharacter != null:
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(self, "modulate:a", -(pow(((playerCharacter.position.x - position.x)/100),2)) + 1, 1)
	else:
		interactable = true
	if !self.visible:
		return
	
	var temp = canInteract
	if playerCharacter and abs(playerCharacter.position.x - position.x) < minimumDistanceFromPlayer and locked == false:
		# print("I go to %s" %next_scene)
		canInteract = true
		interactable = true
	#i just want the portal to work man
	elif playerCharacter and abs(playerCharacter.position.x - position.x) < minimumDistanceFromPlayer and self.name == "YokaiPortal" and Global.dialogueFlags.shuConfront == true:
		canInteract = true
		locked = false
	else:
		# print("I am not interactable")
		canInteract = false
		interactable = false
	if temp != canInteract:
		Sprite2.visible = !Sprite2.visible
		Signals.PlayerCanInteract.emit("button",canInteract)

func ButtonPressed(InteractableObject:String):
	if InteractableObject == "button" && interactable == true && self.name != "YokaiPortal":
		sceneManager.player_pos = player_pos
		print(next_scene)
		SceneTransition.play("gradient_up")
		await SceneTransition.animation_finished
		playerCharacter.queue_free()
		# print("scene transition")
		await get_tree().create_timer(1).timeout
		sceneManager.transition_to_scene(next_scene)
	elif InteractableObject == "button" && interactable == true && self.name == "YokaiPortal" && self.visible == true:
		sceneManager.player_pos = player_pos
		print(next_scene)
		SceneTransition.play("gradient_up")
		await SceneTransition.animation_finished
		playerCharacter.queue_free()
		# print("scene transition")
		await get_tree().create_timer(1).timeout
		sceneManager.transition_to_scene(next_scene)
	elif InteractableObject == "ShowSpirit" && isSpiritButton == true && locked == false && abs(playerCharacter.position.x - position.x) < 60:
		self.visible = true
		turnedVisible = true
		interactable = true
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(self, "modulate:a", -(pow(((playerCharacter.position.x - position.x)/100),2)) + 1, 1)
		if Global.dialogueFlags.spiritRealmUnlocked == false && self.name == "YokaiPortal":
				Global.dialogueFlags.spiritRealmUnlocked = true
				DialogueManager.show_dialogue_balloon_scene(load("res://Scenes/DialogueBalloons/balloon.tscn"), load("res://Assets/Dialogue/Kite.dialogue"), "spiritSightRevealsYokaiRealm", )
		
func ToggleLock(areaName: String, toggled: bool):
	if areaName == self.name:
		if toggled == true:
			self.locked = false
		elif toggled == false:
			self.locked = true
			
func disableVis(resource):
	Sprite2.visible = false
