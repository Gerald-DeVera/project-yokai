extends Node2D

@onready var path: Path2D = $"../BossChargePositions/Path2D"
@onready var pathFollow: PathFollow2D = $"../BossChargePositions/Path2D/PathFollow2D"
var moveSpeed: float = 1000
var loopPath: bool = true

var lastPosition: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#position = pathFollow.global_position
	#lastPosition = position
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	#pathFollow.progress += moveSpeed * delta
	#position = pathFollow.position
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
