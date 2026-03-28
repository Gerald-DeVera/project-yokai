extends Sprite2D

@export var swayforce: float

func _ready() -> void:
	self.material.set_shader_parameter("force", swayforce)
