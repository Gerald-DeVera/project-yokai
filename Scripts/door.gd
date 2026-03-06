extends Node2D

@export var next_scene :String

func _on_exit_area_2d_body_entered(body: Node2D) -> void:
	print("yuh")
	
	if body.is_in_group("Player"):
		var player = body as CharacterBody2D
		player.queue_free()
	await get_tree().create_timer(3.0).timeout
	print("scene transition")
	sceneManager.transition_to_scene(next_scene)
