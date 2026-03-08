extends CharacterBody2D

const speed = 150.0
const jump_velocity = -200.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var canInteract = false
var interactable = ""
var inputDisabled = false
var spiritSightOn = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("Player")
	Signals.PlayerCanInteract.connect(Callable(self,"ChangeInteractionStatus"))
	DialogueManager.dialogue_started.connect(Callable(self,"disableInput"))
	DialogueManager.dialogue_ended.connect(Callable(self,"enableInput"))
	if sceneManager.player_pos:
		global_position = sceneManager.player_pos


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	#Do not continue if we do not allow input for the player
	if inputDisabled:
		return
	
	if Input.is_action_just_pressed("Spirit Sight"):
		spiritSightOn = !spiritSightOn
		print("Spirit Sight = ", spiritSightOn)
		
	#interact
	if canInteract and is_on_floor() and Input.is_action_just_pressed("Interact"):
		disableInput(true)
		Signals.PlayerInteractPressed.emit(interactable)
	#jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	var direction = Input.get_axis("move_left", "move_right")
	#print(direction)
	if direction:
		velocity.x = direction * speed
		#bad temp implementation
		if direction == -1:
			$Sprite2D.frame = 1
		elif direction == 1:
			$Sprite2D.frame = 0
	else:
		velocity.x = move_toward(velocity.x,0, speed)

	move_and_slide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func ChangeInteractionStatus(InteractableObject:String,IsTrue:bool):
	canInteract = IsTrue
	interactable = InteractableObject

func disableInput(resource):
	inputDisabled = true

func enableInput(resource):
	inputDisabled = false
