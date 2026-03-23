extends Sprite2D

@onready var interactButton = $"../YumiPostInterview"

func _ready() -> void:
	Signals.toggleAsset.connect(Callable(self,"ToggleVis"))
	if Global.dialogueFlags.interviewedSagawa == true && Global.dialogueFlags.interviewedYumiStreet == false:
		self.visible = true
		interactButton.locked = false
	elif Global.dialogueFlags.interviewedSagawa == true && Global.dialogueFlags.interviewedYumiStreet == true:
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
			
			
