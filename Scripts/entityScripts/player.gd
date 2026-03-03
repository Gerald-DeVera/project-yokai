extends CharacterBody2D

const speed = 150.0
const jump_velocity = -200.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

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
