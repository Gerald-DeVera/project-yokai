extends Node2D

var beginFalling = false
var isFalling = false
var alternator = false
@onready var selfSprite = $Sprite2D
@onready var playerCharacter = $"../PlayerCharacter"
@onready var physicalBody = $AnimatableBody2D
@onready var physicalBodyOriginalPosition = physicalBody.global_position
@onready var collisionBody = $Area2D
@onready var collisionBodyOriginalPosition = collisionBody.global_position
@onready var originalPosition = global_position
var spritePos : Vector2
var timerVal : float
@export var fallspeed : float
@export var fallAcceleration : float
var originalFallSpeed : float
var checkForPlayerOnFloor = false
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	spritePos = selfSprite.position
	originalFallSpeed = fallspeed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !beginFalling and !isFalling and checkForPlayerOnFloor and playerCharacter and playerCharacter.velocity.y == 0:
		beginFalling = true
	if beginFalling:
		timerVal += delta
		if (int)(timerVal / delta) % 2 == 0:
			if alternator:
				selfSprite.position = spritePos - Vector2(1,0)
			else:
				selfSprite.position = spritePos + Vector2(1,0)
			alternator = !alternator
		if timerVal > 1.5:
			selfSprite.position = spritePos
			isFalling = true
			beginFalling = false
			timerVal = 0
		return
	if isFalling:
		timerVal += delta
		self.global_position += Vector2(0,fallspeed) * delta
		physicalBody.global_position += Vector2(0,fallspeed) * delta
		collisionBody.global_position += Vector2(0,fallspeed) * delta
		fallspeed += fallAcceleration * delta
	if timerVal > 4.5:
		timerVal = 0
		self.global_position = originalPosition
		physicalBody.global_position = physicalBodyOriginalPosition
		collisionBody.global_position = collisionBodyOriginalPosition
		isFalling = false
		fallspeed = originalFallSpeed

func _on_area_2d_area_entered(area: Area2D) -> void:
	checkForPlayerOnFloor = true

func _on_area_2d_area_exited(area: Area2D) -> void:
	checkForPlayerOnFloor = false
