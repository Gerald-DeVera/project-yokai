extends CanvasLayer

@onready var UIAnimation = $AnimationPlayer
@onready var PauseMenu = $HUD/PauseMenu
@onready var Notebook = $HUD/Notebook
@onready var Evidence = $EvidenceUI/InventoryPolaroid/Evidence
@onready var Hotkeys = $Hotkeys
@onready var SpiritHK = $Hotkeys/Spirit
@onready var HealthBar = $HealthBar
@onready var HealthProg = $HealthBar/TextureProgressBar
@onready var HealthAni = $HealthBar/AnimationPlayer
@onready var lowhpflash = $HealthBar/lowhp
@onready var writeSFX = $AudioStreamPlayer
var escapeInputDisabled = true	

func _ready() -> void:
	Signals.updateInfoAnimation.connect(Callable(self,"updateInfo"))
	Signals.damagePlayer.connect(Callable(self,"takeDamage"))
	Signals.toggleEscapeInput.connect(Callable(self,"toggleInput"))
	DialogueManager.dialogue_started.connect(Callable(self,"disableHotkeys"))
	DialogueManager.dialogue_ended.connect(Callable(self,"enableHotkeys"))
	Global.PlayerUIAnimation = UIAnimation
	Global.PlayerUITexture = Evidence
	PauseMenu.visible = false
	Notebook.visible = false
	if Global.hasunlockedSight == true:
		SpiritHK.visible = true
	if get_parent().name == "BossLevel" or get_parent().name == "PlatformingLevel":
		HealthBar.visible = true



func _on_inventory_ui_inventory_close():
	UIAnimation.play_backwards("move")
	await UIAnimation.animation_finished
	Signals.toggleNotebookInput.emit(false)
	Signals.toggleEscapeInput.emit(false)

func _on_inventory_ui_inventory_open():
	UIAnimation.play("RESET")
	await UIAnimation.animation_finished
	UIAnimation.play("move")

func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	UIAnimation.play_backwards("pause_move")

func toggleInput(input: bool) -> void:
	escapeInputDisabled = input


func _physics_process(delta):
	if escapeInputDisabled:
		return
	
	if Input.is_action_just_pressed("PauseMenu"):
		if get_tree().paused != true:
			UIAnimation.play("pause_move")
			get_tree().paused = true
		elif get_tree().paused == true:
			UIAnimation.play_backwards("pause_move")
			get_tree().paused = false
	return

func _on_quit_button_pressed() -> void:
	get_tree().quit()
	
func updateInfo(infoType: String):
	if infoType == "inventory":
		UIAnimation.play("inv_upd")
		writeSFX.play()
	elif infoType == "notebook":
		UIAnimation.play("nte_upd")
		writeSFX.play()
	elif infoType == "invnote":
		UIAnimation.play("nte_upd")
		writeSFX.play()
		await UIAnimation.animation_finished
		UIAnimation.play("inv_upd")
		writeSFX.play()
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
		Signals.toggleInventoryInput.emit(true)
		Signals.toggleNotebookInput.emit(true)
		escapeInputDisabled = true
		await get_tree().create_timer(5.0).timeout
		UIAnimation.play_backwards("tutorial")
		await UIAnimation.animation_finished
		Signals.togglePlayerInput.emit(true)
		escapeInputDisabled = false
		Signals.toggleInventoryInput.emit(false)
		Signals.toggleNotebookInput.emit(false)
		
func disableHotkeys(resource):
		$Hotkeys.visible = false
func enableHotkeys(resource):
		$Hotkeys.visible = true

func takeDamage(damage: int, objectVelocity: Vector2):
		HealthAni.play("lifelost")
		if HealthProg.value <= 3:
			lowhpflash.visible = true
		await HealthAni.animation_finished
		HealthProg.value -= damage
		
