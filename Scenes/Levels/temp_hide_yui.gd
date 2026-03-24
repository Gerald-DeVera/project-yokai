extends ColorRect

@onready var doorAnimate = $AnimationPlayer

func _ready() -> void:
	Signals.openDoor.connect(Callable(self,"revealRoom"))
	if Global.oneshot_assets.has(self.name):
		queue_free()
	
func revealRoom(doorName: String):
	if self.name == doorName:
		doorAnimate.play("reveal")
		Global.oneshot_assets[self.name] = true
		self.queue_free()
