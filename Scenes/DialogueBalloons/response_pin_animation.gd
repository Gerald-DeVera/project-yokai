extends Button

@onready var pin = $Sprite2D
@onready var pinAnimation: AnimationPlayer = $Sprite2D/AnimationPlayer

func play_pin():
		pin.visible = true
		print(pin.position)
		pinAnimation.play("pin")
		print("i be hovered over")
