extends Node2D

@onready var playerCharacter = $PlayerCharacter
var levelVelocity = -350
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playerCharacter.jump_velocity = levelVelocity
	sceneManager.sceneLoadCheck()
