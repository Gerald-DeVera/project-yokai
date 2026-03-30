extends Node2D

@onready var path: PathFollow2D = $ShuOverworldPath/PathFollow2D
@export var speed = 100

func _process(delta: float) -> void:
	if Global.oneshot_assets.has(self.name):
		queue_free()
	path.progress += speed*delta

func _ready() -> void:
	Signals.moveCharacter.connect(Callable(self,"moveBody"))
	if Global.dialogueFlags.shuConfront == true:
		self.visible = true
		await get_tree().create_timer(4.0).timeout
		Global.oneshot_assets[self.name] = true
		self.queue_free()	
