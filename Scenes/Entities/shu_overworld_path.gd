extends Node2D

@onready var path: PathFollow2D = $ShuOverworldPath/PathFollow2D
@export var speed = 100

func _process(delta: float) -> void:
	path.progress += speed*delta

func _ready() -> void:
	Signals.moveCharacter.connect(Callable(self,"moveBody"))
	if Global.dialogueFlags.shuConfront == true:
		self.visible = true
		await get_tree().create_timer(10.0).timeout
		self.queue_free()
