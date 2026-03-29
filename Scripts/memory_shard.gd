extends Sprite2D

func _ready() -> void:
	if Global.oneshot_assets.has(self.name):
		queue_free()
	pass # Replace with function body.
