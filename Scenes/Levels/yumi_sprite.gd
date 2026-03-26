extends Sprite2D

@onready var interactButton = $"../YumiPostInterview"
@onready var yumiAnimate = $AnimationPlayer

func _ready() -> void:
	Signals.toggleAsset.connect(Callable(self,"ToggleVis"))
	Signals.moveCharacter.connect(Callable(self,"moveBody"))
	if Global.dialogueFlags.interviewedSagawa == true && Global.dialogueFlags.interviewedYumiStreet == false && self.get_parent().name == "Overworld":
		self.visible = true
		interactButton.locked = false
	elif Global.dialogueFlags.interviewedSagawa == true && Global.dialogueFlags.interviewedYumiStreet == true && self.get_parent().name == "Overworld":
		self.visible = false
		interactButton.locked = true
	
func ToggleVis(assetName: String, toggled: bool):
	if assetName == self.name:
		if toggled == true:
			self.visible = true
			interactButton.locked = false
		elif toggled == false:
			self.visible = false
			interactButton.locked = true
			

func moveBody(charName: String, event: String):
	if charName == self.name:
		if event == "enterOffice":
			yumiAnimate.play("walk_right")
			var tween = create_tween()
			tween.set_ease(Tween.EASE_OUT)
			tween.set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(self, "position", Vector2(257,250), 0.5)
			print("moving to the spot!")
			var visfadetween = create_tween()
			visfadetween.set_ease(Tween.EASE_OUT)
			visfadetween.set_trans(Tween.TRANS_CUBIC)
			visfadetween.tween_property(self, "modulate:a",1, 0.5)
			await tween.finished
			yumiAnimate.play("idle_right")
		elif event == "exitOffice":
			yumiAnimate.play("walk_left")
			var tween = create_tween()
			tween.set_ease(Tween.EASE_OUT)
			tween.set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(self, "position", Vector2(221.0,250), 0.5)
			var visfadetween = create_tween()
			visfadetween.set_ease(Tween.EASE_OUT)
			visfadetween.set_trans(Tween.TRANS_CUBIC)
			visfadetween.tween_property(self, "modulate:a",0, 0.5)
		elif event == "overworldRun":
			yumiAnimate.play("walk_right")
			var tween = create_tween()
			tween.set_ease(Tween.EASE_OUT)
			tween.set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(self, "position", Vector2(1450.0,288.0), 3)
			await tween.finished
			self.visible = false
		elif event == "turn_left":
			yumiAnimate.play("idle_left")
		elif event == "turn_right":
			yumiAnimate.play("idle_right")
			
