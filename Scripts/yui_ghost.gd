extends Sprite2D

@onready var playerCharacter = $"../PlayerCharacter"
@export var interactable :bool

var minimumDistanceFromPlayer = 35
var spiritButtonVisibilityDistance = 100
var turnedVisible = false

func _ready() -> void:
	Signals.PlayerInteractPressed.connect(Callable(self,"ButtonPressed"))
	if Global.oneshot_assets.has(self.name):
		queue_free()
	pass # Replace with function body.
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.dialogueFlags.evidenceFound == true:
		Global.oneshot_assets[self.name] = true
		self.queue_free()
	if !turnedVisible and playerCharacter and (!playerCharacter.spiritSightOn or abs(playerCharacter.position.x - position.x) > spiritButtonVisibilityDistance):
		self.visible = false
		interactable = false
	else:
		interactable = true
		if self.visible == true and playerCharacter != null:
			var tween = create_tween()
			tween.set_ease(Tween.EASE_OUT)
			tween.set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(self, "modulate:a", -(pow(((playerCharacter.position.x - position.x)/randf_range(100,200)),2)) + 0.6, 1)
	if !self.visible:
		return
		
func ButtonPressed(InteractableObject:String):
	if InteractableObject == "ShowSpirit" && interactable == true:
		self.visible = true
		turnedVisible = true
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(self, "modulate:a", -(pow(((playerCharacter.position.x - position.x)/randf_range(100,200)),2)) + 0.6, 1)
