extends Node

var player_pos: Vector2
var camera_pos: Vector2
#foundQuests (should) consist of the string key/value pairs where the keys are quest names and
#values are their descriptions
var foundQuests: Dictionary
#foundQuotes (should) do the same, but with keys being NPC names and values being the quotes
var foundQuotes: Dictionary
#This should help with better sorting of the Notebook in theory

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


#Camera controls to be accessed from dialogue controls
