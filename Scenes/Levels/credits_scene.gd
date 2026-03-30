extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sceneManager.sceneLoadCheck()
	Signals.playCredits.connect(Callable(self,"rollItBaby"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func rollItBaby():
	await get_tree().create_timer(3.0).timeout
