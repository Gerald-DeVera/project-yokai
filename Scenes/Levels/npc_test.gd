extends Node2D

@onready var path: PathFollow2D = $Path2D/PathFollow2D
@export var speed = 100

func _process(delta: float) -> void:
	path.progress += speed*delta
