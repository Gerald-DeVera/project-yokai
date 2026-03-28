extends Node

@onready var spawners = [
	$bls1,
	$bls2,
	$bls3,
	$bls4,
	$bls5,
	$bls6,
]

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawnLeftToRight()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func spawnRandom() -> void:
	var myNum = rng.randi_range(0, spawners.size()-1)
	spawners[myNum].shoot()
	pass

func spawnLeftToRight() -> void:
	for x in spawners:
		x.shoot()
		await get_tree().create_timer(0.3).timeout


func _on_timer_timeout() -> void:
	print("do stuff")
	spawners[3].shoot()
	pass # Replace with function body.
