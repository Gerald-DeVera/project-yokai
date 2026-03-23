extends Sprite2D

@onready var shuAnimate = $AnimationPlayer

func _ready() -> void:
	Signals.moveCharacter.connect(Callable(self,"moveBody"))
	if Global.dialogueFlags.shuConfront == true && self.get_parent().name == "FlowerShop":
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
