extends Node2D

func _on_exit_area_2d_body_entered(body: Node2D) -> void:
	print("yuh")
	#The body isn't detecting the player is in the right layer for some reason
	#Not entirely sure why yet
	if body.is_in_group("Player"):
		var player = body as CharacterBody2D
		player.queue_free()
	await get_tree().create_timer(3.0).timeout
	print("scene transition")
