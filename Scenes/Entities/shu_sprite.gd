extends Sprite2D

@onready var shuAnimate = $AnimationPlayer

func _ready() -> void:
	Signals.moveCharacter.connect(Callable(self,"moveBody"))
	if Global.dialogueFlags.shuConfront == true && self.get_parent().name == "FlowerShop":
		self.visible = false
	if Global.dialogueFlags.shuSpirit1 == true && self.get_parent().name == "BaseYokaiWorld":
		self.visible = false
	
func moveBody(charName: String, event: String):
	if charName == self.name:
		if event == "exitStore":
			shuAnimate.play("run_left")
			var tween = create_tween()
			tween.set_ease(Tween.EASE_IN)
			tween.set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(self, "position", Vector2(160,250), 1)
			print("moving to the spot!")
		elif event == "yokaiRun":
			shuAnimate.play("run_right")
			var tween = create_tween()
			tween.set_ease(Tween.EASE_IN)
			tween.set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(self, "position", Vector2(1600,165), 1)
			print("moving to the spot!")
			await get_tree().create_timer(2.0).timeout
			self.visible = false
		elif event == "turn_left":
			shuAnimate.play("idle_left")
