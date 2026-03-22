extends Node

var curActiveCheckpoint
@onready var player = $"../PlayerCharacter"
@onready var sceneTransition = $"../SceneTransitionAnimation/AnimationPlayer"
var respawnPoint

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	respawnPoint = player.global_position
	Signals.respawnPlayer.connect(Callable(self, "respawnPlayer"))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func respawnPlayer() -> void:
	Signals.togglePlayerInput.emit(false)
	sceneTransition.play("gradient_up")
	await sceneTransition.animation_finished
	await movePlayer()
	sceneTransition.play("gradient_down")
	await sceneTransition.animation_finished
	Signals.togglePlayerInput.emit(true)

func movePlayer() -> bool:
		player.global_position = respawnPoint
		return true
	
