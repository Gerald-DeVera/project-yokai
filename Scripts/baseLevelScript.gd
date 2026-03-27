extends Node

@onready var YumiSprite = $YumiSprite
@onready var YumiInteract = $YumiPostInterview
@onready var CityBG = $CityParallax
@onready var Buildings = $BuildingContainer
@onready var BGM = $CityBGM
@onready var assets = $AssetContainer
@onready var aura = $Aura
@onready var auraAni = $Aura/AnimationPlayer
@onready var officeModulate = $OfficeInterior
@onready var officeLights = $PointLight2D
@onready var officeBGM = $AudioStreamPlayer
@onready var kijoBoxLight = $DirectionalLight2D
#@onready var SceneTransition = $"../SceneTransitionAnimation/AnimationPlayer"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sceneManager.sceneLoadCheck()
	Signals.transitionToPlatforming.connect(Callable(self,"openTheBox"))
	#Signals.animateScreenWipe.connect(Callable(self,"playTransition"))
	Signals.playBGM.connect(Callable(self,"playBGM"))
	if self.name == "Overworld":
		if Global.TimeOfDay == "Day":
			print("daytime!")
		elif Global.TimeOfDay == "Night":
			print("nighttime!")
			CityBG.modulate = Color(0.765, 0.467, 0.502, 1.0)
			Buildings.modulate = Color(0.659, 0.635, 0.749, 1.0)
			assets.modulate = Color(0.886, 0.714, 0.851, 1.0)
			BGM.stream = load("res://Assets/Audio/BackgroundTracks/NightCity.wav")
			BGM.play()
		pass
	elif self.name == "Office":
		if Global.TimeOfDay == "Day":
			print("daytime!")
			officeModulate.modulate = Color(0.859, 0.886, 0.918, 1.0)
			officeLights.modulate = Color(1.0, 1.0, 1.0, 1.0)
		if Global.TimeOfDay == "Night":
			print("nighttime!")
			officeModulate.modulate = Color(0.804, 0.749, 0.875, 1.0)
			officeLights.modulate = Color(0.694, 0.502, 0.267, 1.0)
		pass
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func openTheBox():
	if self.name == "Office":
		aura.visible = true
		auraAni.play("pulse")
		Signals.shakeCam.emit(true)
		Signals.togglePlayerInput.emit(false)
		Signals.moveCharacter.emit("PlayerCharacter", "box_idle")
		Signals.moveCharacter.emit("YumiSprite", "dragged")
		kijoBoxLight.visible = true
		var tween = create_tween()
		tween.set_ease(Tween.EASE_IN)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(kijoBoxLight, "energy",1.0, 5)
		await tween.finished
		Signals.animateScreenWipe.emit("white_black")
		await get_tree().create_timer(1.0).timeout
		sceneManager.transition_to_scene("PlatformingStage")
		
func playBGM(sceneName: String):
	if sceneName == "Office" && self.name == sceneName:
		officeBGM.play()
	
