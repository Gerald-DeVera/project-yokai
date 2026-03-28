extends Node2D

@onready var playerCharacter = $PlayerCharacter
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playerCharacter.jump_velocity = -350
