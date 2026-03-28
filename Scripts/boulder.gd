extends RigidBody2D

var numOfContacts = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_center_of_mass(Vector2(randi_range(-1,1), randi_range(0,0)))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node) -> void:
	print(get_contact_count())
	if body.is_in_group("Player"):
		print("player")
		Signals.damagePlayer.emit(1, self.linear_velocity)
		queue_free()
	else:
		print("not player")
		numOfContacts += 1
		if numOfContacts >= 2:
			#play blow up animation lmao
			set_collision_layer_value(1, false)
			set_collision_mask_value(1, false)
			await get_tree().create_timer(1.2).timeout
			queue_free()
	pass # Replace with function body.
