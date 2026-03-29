extends Node2D

@onready var YuiSprite = $YuiSpriteSheet
@onready var YumiSprite = $YumiSprite
@onready var memoryBG = $MemoryBG
@onready var dialogue = $MemoryTalk
@onready var leaveRoom = $ExitMemory

func _ready() -> void:
	Signals.memoryUpdate.connect(Callable(self,"changeScene"))
	leaveRoom.player_pos = Global.player_pos
	print(leaveRoom.player_pos)
	if Global.MemoriesEncountered == 0:
		memoryBG.texture = load("res://Assets/Environment/memory_city.png")
		dialogue.dialogueStartingPosition = "yumiMemoryFragment1"
	elif Global.MemoriesEncountered == 1:
		memoryBG.texture = load("res://Assets/Environment/memory_shops.png")
		dialogue.dialogueStartingPosition = "yumiMemoryFragment2"
	elif Global.MemoriesEncountered == 2:
		memoryBG.texture = load("res://Assets/Environment/memory_alleyway.png")
		dialogue.dialogueStartingPosition = "yumiMemoryFragment3"

func changeScene(updateAction: String):
	if updateAction == "YuiFade":
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(YuiSprite, "modulate:a", 0, 1)
	elif updateAction == "YumiFade":
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(YumiSprite, "modulate:a", 0, 1)
	elif updateAction == "BGFade":
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(memoryBG, "modulate:a", 0, 1)
