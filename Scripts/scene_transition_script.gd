extends CanvasLayer

@onready var SceneTransition = $AnimationPlayer

func _ready() -> void:
	Signals.animateScreenWipe.connect(Callable(self,"playTransition"))
	pass

func playTransition(animationName: String):
	if animationName == "gradient_up":
		SceneTransition.play("gradient_up")
	elif animationName == "gradient_down":
		SceneTransition.play("gradient_down")
	elif animationName == "white_in":
		SceneTransition.play("white_in")
	elif animationName == "white_out":
		SceneTransition.play("white_out")
	elif animationName == "white_black":
		SceneTransition.play("white_black")
	elif animationName == "timeskip":
		SceneTransition.play("gradient_up")
		await get_tree().create_timer(3.0).timeout
		SceneTransition.play("gradient_down")
		await SceneTransition.animation_finished
	pass
