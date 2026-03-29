extends Control

@onready var credits = $CreditsUI
@onready var creditsAni = $CreditsUI/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

	
func _on_start_pressed():
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
