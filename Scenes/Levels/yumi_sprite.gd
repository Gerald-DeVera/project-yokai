extends Sprite2D

@onready var interactButton = $"../YumiPostInterview"

func _ready() -> void:
	Signals.toggleAsset.connect(Callable(self,"ToggleVis"))
	
func ToggleVis(assetName: String, toggled: bool):
	if assetName == self.name:
		if toggled == true:
			self.visible = true
			interactButton.locked = false
		elif toggled == false:
			self.visible = false
			interactButton.locked = true
			
			
