extends Control

var runOnce = false
var pageNumber

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func setup() -> void:
	pageNumber = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !visible:
		runOnce = true
		return
	if runOnce:
		setup()
		runOnce = false
