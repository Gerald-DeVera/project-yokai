extends CharacterBody2D


@export var speed = 100

var dir : float
var spawnPos : Vector2
var spawnRot : float
@onready var sprite = $AnimatedSprite2D
@onready var hitbox = $Area2D/CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = spawnPos
	global_rotation = spawnRot
	pass # Replace with function body.


func _physics_process(delta):
	if hitbox.disabled == false:
		velocity = Vector2(0, -speed).rotated(dir)
		move_and_slide()


func _on_timer_timeout() -> void:
	queue_free()
	pass # Replace with function body.


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") && hitbox.disabled != true:
		hitbox.disabled = true
		Signals.damagePlayer.emit(1,self.velocity)
		sprite.play("hit")
		await sprite.animation_finished
		queue_free()
	pass # Replace with function body.
