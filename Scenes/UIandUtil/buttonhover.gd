extends Button

@onready var pinAnimation: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var pin: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	mouse_entered.connect(_on_button_mouse_entered)
	mouse_exited.connect(_on_button_mouse_exited)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_button_mouse_entered():
	pin.visible = true
	print(pin.position)
	pinAnimation.play("pin")

func _on_button_mouse_exited():
	pin.visible = false
