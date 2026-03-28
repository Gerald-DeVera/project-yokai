extends Node2D

@onready var playerCharacter = get_tree().current_scene.get_node("PlayerCharacter")
@onready var collision = $AnimatableBody2D/CollisionShape2D
@export var interactable :bool

var minimumDistanceFromPlayer = 35
var spiritButtonVisibilityDistance = 100
var turnedVisible = false

func _ready() -> void:
	Signals.PlayerInteractPressed.connect(Callable(self,"ButtonPressed"))
	pass # Replace with function body.
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !turnedVisible and playerCharacter and (!playerCharacter.spiritSightOn or abs(playerCharacter.position.x - position.x) > spiritButtonVisibilityDistance):
		collision.disabled = true
		interactable = false
	else:
		interactable = true
		if collision.disabled == false and playerCharacter != null:
			var tween = create_tween()
			tween.set_ease(Tween.EASE_OUT)
			tween.set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(self, "modulate:a", -(pow(((playerCharacter.position.x - position.x)/randf_range(100,200)),2)) + 1, 1)
	if !self.visible:
		return
		
func ButtonPressed(InteractableObject:String):
	if InteractableObject == "ShowSpirit" && interactable == true:
		collision.disabled = false
		turnedVisible = true
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(self, "modulate:a", -(pow(((playerCharacter.position.x - position.x)/randf_range(100,200)),2)) + 1, 1)
