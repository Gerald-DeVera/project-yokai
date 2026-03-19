extends Node

var player_pos: Vector2
var camera_pos: Vector2
var inv: Inv = preload("res://Assets/InventoryItems/playerInventory.tres")

var playerHasItem: bool

#List of NPC Dialogue Flags
#We also use these for one shots
#Enums only story ints, so 0 is false, 1 is true
var dialogueFlags = {
	interviewedSagawa = false,
	testFlag = false
}
var dialoguePrep = {
	dialogueOneShot = false,
	dialogueFilePath = "",
	dialogueStartLine = "",
	dialogueSceneStart = ""
}

#Add new quest via script:
#Global.questsList.insert(newQuestTemplate.new("wuh", false, "but"))
var questsList: QuestsList = preload("res://Assets/Quests/questsList.tres")
var newQuestTemplate = preload("res://Scripts/questItem.gd")

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
	
func testThing():
	print(dialogueFlags.testFlag)

#Camera controls to be accessed from dialogue controls
