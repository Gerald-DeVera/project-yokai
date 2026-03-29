extends Node

@onready var SceneTransition = $SceneTransitionAnimation
@onready var playerCharacter = $PlayerCharacter
var levelVelocity = -350
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playerCharacter.jump_velocity = levelVelocity
	Signals.reloadScene.connect(Callable(self, "restartLevel"))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func restartLevel() -> void:
	Signals.animateScreenWipe.emit("gradient_up")
	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene()
	Signals.animateScreenWipe.emit("gradient_down")
