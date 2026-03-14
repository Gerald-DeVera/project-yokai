extends Control

var checkStatus = false
var statusLastFrame = false
@onready var sprite = $CheckStatus

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if checkStatus != statusLastFrame:
		statusLastFrame = checkStatus
		if checkStatus:
			sprite.texture = "res://Assets/Sprites/checked.png"
		else:
			sprite.texture = "res://Assets/Sprites/unchecked.png"
		
