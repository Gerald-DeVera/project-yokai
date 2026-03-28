extends AudioStreamPlayer

const levelMusic = {
	"cityDay" = preload("res://Assets/Audio/BackgroundTracks/DayCity.wav"),
	"cityNight" = preload("res://Assets/Audio/BackgroundTracks/NightCity.wav"),
	"yokai" = preload("res://Assets/Audio/BackgroundTracks/Yokai.wav"),
	"platforming" = preload("res://Assets/Audio/BackgroundTracks/Plat.wav"),
	"boss" = preload("res://Assets/Audio/BackgroundTracks/Art.wav")
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func playMusic(music: AudioStream, volume = 0.0):
	if stream == music:
		return
	
	stream = music
	volume_db = volume
	play()
	pass

func playLevelMusic(level: String = "cityDay"):
	playMusic(levelMusic[level])
	pass
