extends Camera2D

@export var randShake: float = 0.1
@export var fadeout: float = 30.0
@export var isShaking: bool = false

var randNum = RandomNumberGenerator.new()
var shake_strength: float = 0.0

func shake_Camera():
	shake_strength = randShake

func _ready() -> void:
	Signals.shakeCam.connect(Callable(self,"toggleShake"))
	randShake = 0.1

func _process(delta):
	if isShaking:
		if randShake < 5.0:
			randShake += 0.01
		shake_Camera()
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength,0,fadeout * delta)
		offset = randomOffset()
	
func randomOffset() -> Vector2:
	return Vector2(randNum.randf_range(-shake_strength,shake_strength), randNum.randf_range(-shake_strength,shake_strength))
	
func toggleShake(toggle: bool):
	if toggle == true:
		isShaking = true
	elif toggle == false:
		isShaking = false
