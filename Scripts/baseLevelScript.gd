extends Node

@onready var YumiSprite = $YumiSprite
@onready var YumiInteract = $YumiPostInterview
@onready var CityBG = $CityParallax
@onready var Buildings = $BuildingContainer
@onready var BGM = $CityBGM
@onready var assets = $AssetContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sceneManager.sceneLoadCheck()
	if self.name == "Overworld":
		if Global.TimeOfDay == "Day":
			print("daytime!")
		if Global.TimeOfDay == "Night":
			print("nighttime!")
			CityBG.modulate = Color(0.765, 0.467, 0.502, 1.0)
			Buildings.modulate = Color(0.659, 0.635, 0.749, 1.0)
			assets.modulate = Color(0.886, 0.714, 0.851, 1.0)
			BGM.stream = load("res://Assets/Audio/BackgroundTracks/NightCity.wav")
			BGM.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
