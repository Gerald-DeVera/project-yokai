extends CanvasLayer

@onready var UIAnimation = $AnimationPlayer
@onready var PauseMenu = $HUD/PauseMenu
@onready var Notebook = $HUD/Notebook
@onready var Evidence = $EvidenceUI/InventoryPolaroid/Evidence
@onready var Hotkeys = $Hotkeys
@onready var SpiritHK = $Hotkeys/Spirit

func _ready() -> void:
	Signals.updateInfoAnimation.connect(Callable(self,"updateInfo"))
	DialogueManager.dialogue_started.connect(Callable(self,"disableHotkeys"))
	DialogueManager.dialogue_ended.connect(Callable(self,"enableHotkeys"))
	Global.PlayerUIAnimation = UIAnimation
	Global.PlayerUITexture = Evidence
	PauseMenu.visible = false
	Notebook.visible = false
	if Global.hasunlockedSight == true:
		SpiritHK.visible = true
		

func _on_inventory_ui_inventory_close():
	UIAnimation.play_backwards("move")

func _on_inventory_ui_inventory_open():
	UIAnimation.play("RESET")
	await UIAnimation.animation_finished
	UIAnimation.play("move")

func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	UIAnimation.play_backwards("pause_move")

func _physics_process(delta):
	return

func _on_quit_button_pressed() -> void:
	get_tree().quit()
	
func updateInfo(infoType: String):
	if infoType == "inventory":
		UIAnimation.play("inv_upd")
	elif infoType == "notebook":
		UIAnimation.play("nte_upd")
	elif infoType == "invnote":
		UIAnimation.play("nte_upd")
		await UIAnimation.animation_finished
		UIAnimation.play("inv_upd")
	elif infoType == "spirit":
		UIAnimation.play("spiritsight")
		await UIAnimation.animation_finished
		Signals.unlockSpiritSight.emit()
	elif infoType == "spiritdone":
		UIAnimation.play_backwards("spiritsight")
		await UIAnimation.animation_finished
		DialogueManager.show_dialogue_balloon_scene(load("res://Scenes/DialogueBalloons/balloon.tscn"), load("res://Assets/Dialogue/Kite.dialogue"), "spiritSightFirstUse", )
		SpiritHK.visible = true
	elif infoType == "tutorial":
		await get_tree().create_timer(1.0).timeout
		UIAnimation.play("tutorial")
		Signals.togglePlayerInput.emit(false)
		await get_tree().create_timer(5.0).timeout
		UIAnimation.play_backwards("tutorial")
		await UIAnimation.animation_finished
		Signals.togglePlayerInput.emit(true)
		
func disableHotkeys(resource):
		$Hotkeys.visible = false
func enableHotkeys(resource):
		$Hotkeys.visible = true
