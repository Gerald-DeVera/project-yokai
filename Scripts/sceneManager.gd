extends Node


#What scrit is this?
#This is the sceneManager script! It contains a dictionary that contains paths to scenes that 
#will be called by doors we create. It also contains the script needed to transition us to other scenes
var scenes : Dictionary = { "Level1": "res://Scenes/Levels/overworld.tscn" ,
							"Level2": "res://Scenes/Levels/testLevel.tscn"}

func transition_to_scene(level : String):
	var scene_path : String = scenes.get(level)
	
	if scene_path != null:
		await get_tree().create_timer(1.0).timeout
		get_tree(). change_scene_to_file(scene_path)
