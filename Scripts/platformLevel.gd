extends Node2D

var levelVelocity = -350
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PlayerCharacter.jump_velocity = levelVelocity
	sceneManager.sceneLoadCheck()
	Signals.reloadScene.connect(Callable(self, "restartLevel"))
	
func restartLevel() -> void:
	Signals.animateScreenWipe.emit("gradient_up")
	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene()
	Signals.animateScreenWipe.emit("gradient_down")
