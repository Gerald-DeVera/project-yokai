extends Node2D

@onready var doorAnimate = $AnimationPlayer

func _ready() -> void:
	Signals.openDoor.connect(Callable(self,"animateDoor"))
	
func animateDoor(doorName: String, animateName: String):
	if self.name == doorName:
		doorAnimate.play(animateName)
