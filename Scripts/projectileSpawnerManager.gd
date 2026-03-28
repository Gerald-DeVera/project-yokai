extends Node

@onready var spawners = [
	$spawner1,
	$spawner2,
	$spawner3
]
var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_cooldown_timeout() -> void:
	var myNum = rng.randi_range(0, spawners.size()-1)
	spawners[myNum].shoot()
	pass # Replace with function body.
