extends Node


#What scrit is this?
#This is the sceneManager script! It contains a dictionary that contains paths to scenes that 
#will be called by doors we create. It also contains the script needed to transition us to other scenes
var scenes : Dictionary = { "City": "res://Scenes/Levels/overworld.tscn" ,
							"Office": "res://Scenes/Levels/office.tscn" ,
							"Yokai": "res://Scenes/Levels/baseYokaiWorld.tscn", 
							"Ramen": "res://Scenes/Levels/ramenshop.tscn",
							"Alley": "res://Scenes/Levels/alleyway.tscn",
							"Flower": "res://Scenes/Levels/flower_shop.tscn",
							"Clothing": "res://Scenes/Levels/clothing_shop.tscn",
							"YokaiHome": "res://Scenes/Levels/yokaihome.tscn"}
var player_pos: Vector2
var currentScene = ""

func transition_to_scene(level : String):
	var scene_path : String = scenes.get(level)
	
	if scene_path != null:
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file(scene_path)
		currentScene = level
		

func sceneLoadCheck():
	Signals.togglePlayerInput.emit(false)
	Signals.toggleInventoryInput.emit(true)
	Signals.toggleNotebookInput.emit(false)
	await get_tree().create_timer(1.2).timeout
	if Global.dialoguePrep.dialogueOneShot == true and currentScene == Global.dialoguePrep.dialogueSceneStart:
		Global.initiateDialogueOneShot()
	else:
		Signals.togglePlayerInput.emit(true)
		Signals.toggleInventoryInput.emit(false)
		Signals.toggleNotebookInput.emit(true)
