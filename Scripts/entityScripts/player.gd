extends CharacterBody2D

const speed = 150.0
const jump_velocity = -200.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var canInteract = false
var interactable = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("Player")
	Signals.PlayerCanInteract.connect(Callable(self,"ChangeInteractionStatus"))


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	#interact
	if canInteract and is_on_floor() and Input.is_action_just_pressed("Interact"):
		Signals.PlayerInteractPressed.emit(interactable)
	#jump
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = jump_velocity
	
	var direction = Input.get_axis("ui_left", "ui_right")
	#print(direction)
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x,0, speed)

	move_and_slide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func ChangeInteractionStatus(InteractableObject:String,IsTrue:bool):
	canInteract = IsTrue
	interactable = InteractableObject
