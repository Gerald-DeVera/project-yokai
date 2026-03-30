extends Node

@onready var SceneTransition = $SceneTransitionAnimation
@onready var playerCharacter = $PlayerCharacter
@onready var aura = $Aura
@onready var auraAni = $Aura/AnimationPlayer
@onready var kijoBoxLight = $DirectionalLight2D

var levelVelocity = -350
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sceneManager.sceneLoadCheck()
	playerCharacter.jump_velocity = levelVelocity
	Signals.reloadScene.connect(Callable(self, "restartLevel"))
	Signals.transitionToPlatforming.connect(Callable(self,"openTheBox"))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func restartLevel() -> void:
	Signals.animateScreenWipe.emit("gradient_up")
	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene()
	Signals.animateScreenWipe.emit("gradient_down")

func openTheBox():
	if self.name == "BossLevel":
		aura.visible = true
		auraAni.play("pulse")
		Signals.shakeCam.emit(true)
		Signals.togglePlayerInput.emit(false)
		Signals.moveCharacter.emit("PlayerCharacter", "box_idle_right")
		Signals.moveCharacter.emit("YumiSprite", "dragged")
		kijoBoxLight.visible = true
		var tween = create_tween()
		tween.set_ease(Tween.EASE_IN)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(kijoBoxLight, "energy",1.0, 1.3)
		await tween.finished
		var tween2 = create_tween()
		tween2.set_ease(Tween.EASE_IN)
		tween2.set_trans(Tween.TRANS_CUBIC)
		tween2.tween_property(kijoBoxLight, "color", Color(1, 1, 1, 1), 5)
		#Signals.animateScreenWipe.emit("white_black")
		#await get_tree().create_timer(1.0).timeout
		#sceneManager.transition_to_scene("Office")
