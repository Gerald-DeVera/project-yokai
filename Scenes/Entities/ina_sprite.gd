extends Sprite2D

func _ready() -> void:
	Signals.toggleAsset.connect(Callable(self,"ToggleVis"))
	if Global.dialogueFlags.keyYokaifound == true && Global.dialogueFlags.InaFound == false && self.get_parent().name == "BaseYokaiWorld":
		self.visible = true
	elif Global.dialogueFlags.keyYokaifound == true && Global.dialogueFlags.InaFound == true && self.get_parent().name == "BaseYokaiWorld":
		self.visible = false
	elif Global.dialogueFlags.keyYokaifound == true && Global.dialogueFlags.InaFound == true && Global.dialogueFlags.gotBeans == false && self.get_parent().name == "YokaiHome":
		self.visible = true
	elif Global.dialogueFlags.InaShuPlan == true && self.get_parent().name == "Overworld":
		self.visible = true
	elif Global.dialogueFlags.keyYokaifound == true && Global.dialogueFlags.InaFound == true && Global.dialogueFlags.gotBeans == true && self.get_parent().name == "YokaiHome":
		self.visible = true

func ToggleVis(assetName: String, toggled: bool):
	if assetName == self.name:
		if toggled == true:
			self.visible = true
		elif toggled == false:
			self.visible = false
