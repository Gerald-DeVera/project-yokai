extends Node

var PlayerUIAnimation: AnimationPlayer
var PlayerUITexture: Sprite2D

var player_pos: Vector2
var camera_pos: Vector2
var inv: Inv = preload("res://Assets/InventoryItems/playerInventory.tres")

var playerHasItem: bool
var evidenceFound = 0 #for alleyway scene
var YuiExamined = 0
var spiritTutorial = false
var hasunlockedSight = false #set to false at beginning of game pls
var MemoryStarting: String = "yumiMemoryFragment1"
var MemoriesEncountered = 0

#time state
var TimeOfDay: String = "Day"

#preload a bunch of textures for evidence in cutscenes
var evidenceTextures = {
	"box": preload("res://Assets/UI/Items/item_closeup_box.png"),
	"yui1": preload("res://Assets/UI/Items/item_closeup_yui1.png"),
	"yui2": preload("res://Assets/UI/Items/item_closeup_yui2.png"),
	"hand": preload("res://Assets/UI/Items/item_closeup_hand.png"),
	"bracelet1": preload("res://Assets/UI/Items/item_closeup_bracelet1.png"),
	"bracelet2": preload("res://Assets/UI/Items/item_closeup_bracelet2.png"),
	"beans": preload("res://Assets/UI/Items/item_closeup_beans.png"),
	"flowers": preload("res://Assets/UI/Items/item_closeup_flowers.png"),
	"id": preload("res://Assets/UI/Items/item_closeup_id.png"),
	"phone": preload("res://Assets/UI/Items/item_closeup_phone.png"),
	"receipt": preload("res://Assets/UI/Items/item_closeup_receipt.png"),
	"wallet": preload("res://Assets/UI/Items/item_closeup_wallet.png")
}

#stuff to queue free
var oneshot_assets = {}

#locked dialogue
var locked_dialogue = {}
#unlocked dialogue
var unlocked_dialogue = {}

#List of NPC Dialogue Flags
#We also use these for one shots
#Enums only story ints, so 0 is false, 1 is true
var dialogueFlags = {
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
	defeatedKijo = false,
}

var YuiOptions = {
	bracelet = false,
	pockets = false,
	wounds = false
}

var dialoguePrep = {
	dialogueOneShot = false,
	dialogueFilePath = "",
	dialogueStartLine = "",
	dialogueSceneStart = ""
}

#Add new quest via script:
#Global.questsList.insert(newQuestTemplate.new("QuestName", true/false, "QuestDescription"))
var questsList: QuestsList = preload("res://Assets/Quests/questsList.tres")
const newQuestTemplate = preload("res://Scripts/questItem.gd")

#Global.npcProfileList.insert(npcInfoTemplate.new("MyName", "PictureFilePath", "Bio", ["Quote1", "Quote2", ...]))
var npcProfileList: NPC_Profiles = preload("res://Assets/NotebookNPCProfiles/npcNotebookProfiles.tres")
const npcInfoTemplate = preload("res://Scripts/npcNotebookProfile.gd")
#Example for adding NPC data


#const questInfoTemplate = preload("res://Scripts/questResourceTemplate.gd")
#var foundQuests = [questInfoTemplate.new("test",false,"Go to the place and do the thing")]
#Example for adding Quest
#Global.foundQuests.append(Global.questInfoTemplate.new([quest info]))

#Used in dialogue manager to look for a certain item, or can call for other events
func searchInv(target_item: String):
	for item in inv.items:
		if item != null && item.name == target_item:
			print(item.name)
			playerHasItem = true
			break
		else:
			playerHasItem = false
		
#Show evidence
func showEvidence(evidenceName: String):
	PlayerUITexture.texture = evidenceTextures[evidenceName]
	PlayerUIAnimation.play("evidence")
	
func hideEvidence():
	PlayerUIAnimation.play_backwards("evidence")
#Camera controls to be accessed from dialogue controls
func grabCameraPos():
	camera_pos = get_viewport().get_camera_2d().position
	print("Grabbed position!")

func moveCamera(target_position: Vector2):
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	var camera_node = get_viewport().get_camera_2d()
	tween.tween_property(camera_node, "position", target_position, 0.5)
	print("moving to the spot!")
	
func resetCamera():
	var camera_node = get_viewport().get_camera_2d()
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(camera_node, "position", camera_pos, 0.5)
	print("moving back!")
	
func zoomCamera(zoomAmt: Vector2):
	var camera_node = get_viewport().get_camera_2d()
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(camera_node, "zoom", zoomAmt, 0.5)

func prepareDialogue(dialogueFlag, dialogueFP, dialogueSL, sceneToStart):
	dialogueFlags[dialogueFlag] = true
	dialoguePrep.dialogueFilePath = dialogueFP
	dialoguePrep.dialogueStartLine = dialogueSL
	dialoguePrep.dialogueSceneStart = sceneToStart
	dialoguePrep.dialogueOneShot = true	
	return

func finishOneShot(dialogueFlag):
	dialogueFlags[dialogueFlag] = false
	dialoguePrep.dialogueFilePath = ""
	dialoguePrep.dialogueStartLine = ""
	dialoguePrep.dialogueSceneStart = ""
	dialoguePrep.dialogueOneShot = false
	
func initiateDialogueOneShot():
	if dialoguePrep.dialogueOneShot == true and sceneManager.currentScene == dialoguePrep.dialogueSceneStart:
		
		DialogueManager.show_dialogue_balloon_scene(load("res://Scenes/DialogueBalloons/balloon.tscn"), load(dialoguePrep.dialogueFilePath), dialoguePrep.dialogueStartLine)
	return
	
func evidenceCounter():
	evidenceFound += 1
	if evidenceFound == 3:
		#await get_tree().create_timer(1.0).timeout
		DialogueManager.show_dialogue_balloon_scene(load("res://Scenes/DialogueBalloons/balloon.tscn"), load("res://Assets/Dialogue/Kite.dialogue"), "allEvidenceFoundAlley")

func examineYui(option: String):
	if YuiOptions[option] != true:
		YuiExamined += 1	
		YuiOptions[option] = true

func markPreviousQuest(questName: QuestItem):
	var index = questsList.quests.find(questName)
	questsList.quests[index].completionStatus = true
	
func _physics_process(delta: float) -> void:
		if Input.is_action_just_pressed("Fullscreen"):
			if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			else:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
