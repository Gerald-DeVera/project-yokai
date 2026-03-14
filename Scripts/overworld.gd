extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.dialogueOneShot == true:
		if(Global.dialogueFlags.testFlag == true):
			DialogueManager.show_dialogue_balloon_scene(load("res://Scenes/DialogueBalloons/balloon.tscn"), load("res://Assets/Dialogue/Test.dialogue"), "oneShotTest", )
		pass
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
