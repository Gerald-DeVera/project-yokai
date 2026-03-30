extends Control

@onready var credits = $CreditsUI
@onready var creditsAni = $CreditsUI/AnimationPlayer

# List of global variables to reset on new game:
var defaultinv: Inv = preload("res://Assets/InventoryItems/defaultplayerInventory.tres")
var defaultquestsList: QuestsList = preload("res://Assets/Quests/questsList.tres")
var defaultnpcProfileList: NPC_Profiles = preload("res://Assets/NotebookNPCProfiles/npcNotebookProfiles.tres")

var defaultevidenceFound = 0 #for alleyway scene
var defaultYuiExamined = 0
var defaultspiritTutorial = false
var defaulthasunlockedSight = false
var defaultMemoryStarting: String = "yumiMemoryFragment1"
var defaultMemoriesEncountered = 0

#time state
var defaultTimeOfDay: String = "Day"
#stuff to queue free
var defaultoneshot_assets = {}
#locked dialogue
var defaultlocked_dialogue = {}
#unlocked dialogue
var defaultunlocked_dialogue = {}

#List of NPC Dialogue Flags
var defaultdialogueFlags = {
	keyWitnessfound = false,
	uselessWitnessasked = false,
	interviewedSagawa = false,
	interviewedClothier = false,
	interviewedShu = false,
	interviewedYumiStreet = false,
	evidenceFound = false,
	shuConfront = false,
	spiritRealmUnlocked = false,
	shuSpirit1 = false,
	shuSpirit2 = false,
	shuExplain = false,
	confirmedYui = false,
	uselessYokaifound = false,
	keyYokaifound = false,
	InaFound = false,
	InaShuPlan = false,
	gotBeans = false,
	defeatedKijo = false
}

var defaultYuiOptions = {
	bracelet = false,
	pockets = false,
	wounds = false
}

# Called when the node enters the scene tree for the first time.
func _ready():
	audioManager.playLevelMusic("cityNight")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

	
func _on_start_pressed():
	$Start.disabled = true
	resetGame()
	Signals.animateScreenWipe.emit("gradient_up")
	await get_tree().create_timer(3.0).timeout
	Global.prepareDialogue("StartGame", "res://Assets/Dialogue/Yumi.dialogue", "OpeningScene", "Office")
	sceneManager.transition_to_scene("Office")

func _on_credits_pressed():
	if credits.visible == false:
		print("credits!")
		credits.visible = true
		creditsAni.play("toggle")
	elif credits.visible == true:
		creditsAni.play_backwards("toggle")
		await creditsAni.animation_finished
		credits.visible = false
	pass # Replace with function body.

func _on_quit_pressed():
	get_tree().quit()
	#should bring up y/n? 
	pass # Replace with function body.
	
func resetGame():
	Global.inv.items = defaultinv.items
	Global.questsList.quests = defaultquestsList.quests
	Global.npcProfileList.profileInfo = defaultnpcProfileList.profileInfo
	Global.evidenceFound = defaultevidenceFound
	Global.YuiExamined = defaultYuiExamined
	Global.spiritTutorial = defaultspiritTutorial
	Global.hasunlockedSight = defaulthasunlockedSight
	Global.MemoryStarting = defaultMemoryStarting
	Global.MemoriesEncountered = defaultMemoriesEncountered
	Global.TimeOfDay = defaultTimeOfDay
	Global.oneshot_assets = defaultoneshot_assets
	Global.locked_dialogue = defaultlocked_dialogue
	Global.unlocked_dialogue = defaultunlocked_dialogue
	Global.dialogueFlags = defaultdialogueFlags
	Global.YuiOptions = defaultYuiOptions
