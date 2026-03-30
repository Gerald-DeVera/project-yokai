extends Sprite2D

@onready var yuiAnimate = $AnimationPlayer

func _ready() -> void:
	Signals.moveCharacter.connect(Callable(self,"moveBody"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func moveBody(charName: String, event: String):
	if charName == self.name:
		if event == "enterOffice":
			yuiAnimate.play("walk")
			var tween = create_tween()
			tween.set_ease(Tween.EASE_OUT)
			tween.set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(self, "position", Vector2(266.0,252), 0.5)
			print("moving to the spot!")
			var visfadetween = create_tween()
			visfadetween.set_ease(Tween.EASE_OUT)
			visfadetween.set_trans(Tween.TRANS_CUBIC)
			visfadetween.tween_property(self, "modulate:a",1, 0.5)
			await tween.finished
			yuiAnimate.play("idle_right")
		elif event == "hide":
			self.visible = false
