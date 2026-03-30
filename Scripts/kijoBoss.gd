extends Node2D

func _ready() -> void:
	Signals.moveCharacter.connect(Callable(self,"moveBody"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func moveBody(charName: String, event: String):
	if charName == self.name:
		if event == "flyAway1":
			var tween = create_tween()
			tween.set_ease(Tween.EASE_OUT)
			tween.set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(self, "position", Vector2(-15.0,-497.0), 1)
		elif event == "flyAway2":
			var tween = create_tween()
			tween.set_ease(Tween.EASE_OUT)
			tween.set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(self, "position", Vector2(2139.0,-509.0), 2)
		elif event == "flyAway3":
			var tween = create_tween()
			tween.set_ease(Tween.EASE_OUT)
			tween.set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(self, "position", Vector2(4577.0,-786.0), 3)
