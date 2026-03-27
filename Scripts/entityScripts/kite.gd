extends CharacterBody2D
@export var move_speed: float = 100

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")

func _ready() -> void:
	if player != null:
		position = player.global_position +Vector2(10,-20)


func _physics_process(delta: float) -> void:
	if player != null:
		if abs(player.global_position.x-position.x) > 20 && abs(player.global_position.x-position.x) < 50:
			var direction = position.direction_to(player.global_position+Vector2(0,-20)).normalized()
			velocity = direction * move_speed
			move_and_slide()
		elif abs(player.global_position.x-position.x) > 50 && abs(player.global_position.x-position.x) < 100: 
			var direction = position.direction_to(player.global_position+Vector2(0,-20)).normalized()
			velocity = direction * move_speed * 1.5
			move_and_slide()
		elif abs(player.global_position.x-position.x) > 100: 
			position = player.global_position +Vector2(10,-20)
		else:
			velocity.x = move_toward(velocity.x, 0, 100 * delta)
		if position.x > player.global_position.x:
			$KiteSpriteSheet/AnimationPlayer.play("idle_left")
		else:
			$KiteSpriteSheet/AnimationPlayer.play("idle_right")
