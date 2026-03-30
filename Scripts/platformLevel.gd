extends Node2D

var levelVelocity = -350
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PlayerCharacter.jump_velocity = levelVelocity
	sceneManager.sceneLoadCheck()
