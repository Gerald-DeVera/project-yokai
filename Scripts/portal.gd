extends Node2D

class_name portal

@export var pairedPortal : portal
@export var direction : Vector2i
var velocityMultiplier = 1.0
var upwardBoostVelocity = -200
@onready var playerCharacter = $"../PlayerCharacter"
var playerOffset = 10

var canTeleport = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if direction == Vector2i.UP:
		rotation_degrees = 180
	if direction == Vector2i.LEFT:
		rotation_degrees = 90
	if direction == Vector2i.RIGHT:
		rotation_degrees = -90


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	if canTeleport:
		Signals.togglePlayerInput.emit(false)
		pairedPortal.canTeleport = false
		canTeleport = false
		playerCharacter.position = pairedPortal.position
		if pairedPortal.direction == Vector2i.UP:
			playerCharacter.position.y -= playerOffset
			if direction == Vector2i.LEFT || direction == Vector2i.RIGHT:
				var tempVal =  playerCharacter.velocity.y
				playerCharacter.velocity.y = abs(playerCharacter.velocity.x) * -1 * velocityMultiplier
				playerCharacter.velocity.x = tempVal
			elif direction == Vector2i.UP:
				playerCharacter.velocity.y *= -1 * velocityMultiplier
			return
		if pairedPortal.direction == Vector2i.DOWN:
			playerCharacter.position.y += playerOffset
			if direction == Vector2i.LEFT || direction == Vector2i.RIGHT:
				var tempVal = playerCharacter.velocity.y
				playerCharacter.velocity.y = abs(playerCharacter.velocity.x) * velocityMultiplier
				playerCharacter.velocity.x = 0
			elif direction == Vector2i.DOWN:
				playerCharacter.velocity.y *= -1 * velocityMultiplier
			return
		if pairedPortal.direction == Vector2i.LEFT:
			playerCharacter.position.x -= playerOffset
			if direction == Vector2i.UP || direction == Vector2i.DOWN:
				playerCharacter.velocity.x = abs(playerCharacter.velocity.y) * -1 * velocityMultiplier
				playerCharacter.velocity.y = upwardBoostVelocity
			elif direction == Vector2i.LEFT:
				playerCharacter.velocity.x *= -1 * velocityMultiplier
			return
		if pairedPortal.direction == Vector2i.RIGHT:
			playerCharacter.position.x += playerOffset
			if direction == Vector2i.UP || direction == Vector2i.DOWN:
				playerCharacter.velocity.x = abs(playerCharacter.velocity.y) * velocityMultiplier
				playerCharacter.velocity.y = upwardBoostVelocity
			elif direction == Vector2i.RIGHT:
				playerCharacter.velocity.x *= -1 * velocityMultiplier

func _on_area_2d_area_exited(area: Area2D) -> void:
	await get_tree().create_timer(0.2).timeout
	Signals.togglePlayerInput.emit(true)
	canTeleport = true
	pairedPortal.canTeleport = true
