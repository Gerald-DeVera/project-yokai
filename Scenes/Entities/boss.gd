extends Node2D

func _ready() -> void:
	Signals.moveCharacter.connect(Callable(self,"moveBody"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func moveBody(charName: String, event: String):
	if charName == self.name:
		if event == "enterBox":
			var tween = create_tween()
			tween.set_ease(Tween.EASE_OUT)
			tween.set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(self, "position", Vector2(6268.0,-133.0), 40)
