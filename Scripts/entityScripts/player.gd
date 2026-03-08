extends CharacterBody2D

const speed = 150.0
const jump_velocity = -200.0	

@export var inventory: Inv

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var canInteract = false
var interactable = ""
var inputDisabled = false
var spiritSightOn = false
var direction: Vector2
var hasStopped = true

@onready var movement_state_machine = $Animations/AnimationTree.get("parameters/MovementStateMachine/playback")
@onready var domain_expansion = $DomainExpansion/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("Player")
	Signals.PlayerCanInteract.connect(Callable(self,"ChangeInteractionStatus"))
	DialogueManager.dialogue_started.connect(Callable(self,"disableInput"))
	DialogueManager.dialogue_ended.connect(Callable(self,"enableInput"))
	Signals.togglePlayerInput.connect(Callable(self,"toggleInput"))
	if sceneManager.player_pos:
		global_position = sceneManager.player_pos
	inventory.makeReady()


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("Fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	#Do not continue if we do not allow input for the player
	if inputDisabled:
		return

	if Input.is_action_just_pressed("Spirit Sight"):
		spiritSightOn = !spiritSightOn
		print("Spirit Sight = ", spiritSightOn)
		domain_expansion.play("spirit_sense")
		
	#interact
	if canInteract and is_on_floor() and Input.is_action_just_pressed("Interact"):
		#disableInput(true)
		Signals.PlayerInteractPressed.emit(interactable)
	#jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	var direction = Input.get_axis("move_left", "move_right")
	#print(direction)
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x,0, speed)
	
	animate(direction)
	move_and_slide()
	get_basic_input()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func ChangeInteractionStatus(InteractableObject:String,IsTrue:bool):
	canInteract = IsTrue
	interactable = InteractableObject

func toggleInput(toggle: bool):
	#true
	if toggle:
		enableInput(true)
	else:
		disableInput(false)

func disableInput(resource):
	inputDisabled = true
	movement_state_machine.travel("IdleSet")

func enableInput(resource):
	inputDisabled = false
	
#ANIMATIONTREE CONTROLLLLLLL
func animate(direction):
	if direction:
		movement_state_machine.travel("RunSet")
		#tween_machine.travel("Windup")
		$Animations/AnimationTree.set("parameters/MovementStateMachine/RunSet/blend_position", Vector2(direction,0))
		$Animations/AnimationTree.set("parameters/MovementStateMachine/IdleSet/blend_position", Vector2(direction,0))
		$Animations/AnimationTree.set("parameters/WindupSpace/blend_position",Vector2(direction,0))
		$Animations/AnimationTree.set("parameters/EaseOutSpace/blend_position",Vector2(direction,0))
		#$Animations/AnimationTree.set("parameters/TweenMachine/Windup/blend_position", Vector2(direction,0))
	else:
		movement_state_machine.travel("IdleSet")
		if hasStopped != true && Input.is_action_just_pressed("move_left") or hasStopped != true && Input.is_action_just_pressed("move_right"):
			$Animations/AnimationTree.set("parameters/animation_tween/blend_amount", 1)
			$Animations/AnimationTree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
			await $Animations/AnimationTree.animation_finished
		hasStopped = true
			
	if not is_on_floor():
		movement_state_machine.travel("JumpSet")
		$Animations/AnimationTree.set("parameters/MovementStateMachine/JumpSet/blend_position", Vector2(direction,0))
	#Added for redundancy
	if inputDisabled == true:
		movement_state_machine.travel("IdleSet")

func get_basic_input():
	if hasStopped == true && Input.is_action_just_pressed("move_left") or hasStopped == true && Input.is_action_just_pressed("move_right"):
		$Animations/AnimationTree.set("parameters/animation_tween/blend_amount", 0)
		$Animations/AnimationTree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		hasStopped = false
