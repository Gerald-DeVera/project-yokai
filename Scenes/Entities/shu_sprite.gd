extends Sprite2D

@onready var shuAnimate = $AnimationPlayer

func _ready() -> void:
	Signals.moveCharacter.connect(Callable(self,"moveBody"))
	if Global.dialogueFlags.shuConfront == true && self.get_parent().name == "FlowerShop":
		self.visible = false
	if Global.dialogueFlags.shuSpirit1 == true && self.get_parent().name == "BaseYokaiWorld" && self.name == "ShuSprite":
		self.visible = false
	if Global.dialogueFlags.shuSpirit1 == true && Global.dialogueFlags.shuSpirit2 == true && self.get_parent().name == "BaseYokaiWorld" && self.name == "ShuSprite2":
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
		elif event == "yokaiHide":
			shuAnimate.play("run_right")
			var tween = create_tween()
			tween.set_ease(Tween.EASE_IN)
			tween.set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(self, "position", Vector2(2391.0,165), 0.5)
			var visfadetween = create_tween()
			visfadetween.set_ease(Tween.EASE_OUT)
			visfadetween.set_trans(Tween.TRANS_CUBIC)
			visfadetween.tween_property(self, "modulate", Color(1,1,1,0), 1)
		elif event == "turn_left":
			shuAnimate.play("idle_left")
		elif event == "turn_right":
			shuAnimate.play("idle_right")
		elif event == "enterOffice":
			shuAnimate.play("run_right")
			var tween = create_tween()
			tween.set_ease(Tween.EASE_OUT)
			tween.set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(self, "position", Vector2(238.0,252), 0.2)
			print("moving to the spot!")
			var visfadetween = create_tween()
			visfadetween.set_ease(Tween.EASE_OUT)
			visfadetween.set_trans(Tween.TRANS_CUBIC)
			visfadetween.tween_property(self, "modulate:a",1, 0.5)
			await tween.finished
			shuAnimate.play("idle_right")
		elif event == "hide":
			self.visible = false
