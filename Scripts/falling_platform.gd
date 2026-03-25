extends Node2D

var beginFalling = false
var isFalling = false
var alternator = false
@onready var selfSprite = $Sprite2D
@onready var playerCharacter = $"../PlayerCharacter"
@onready var physicalBody = $AnimatableBody2D
@onready var physicalBodyOriginalPosition = physicalBody.position
@onready var collisionBody = $Area2D
@onready var collisionBodyOriginalPosition = collisionBody.position
@onready var originalPosition = position
var spritePos : Vector2
var timerVal : int
@export var fallspeed : float
@export var fallAcceleration : float
var originalFallSpeed : float
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	spritePos = selfSprite.position
	originalFallSpeed = fallspeed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if beginFalling:
		timerVal += 1
		if timerVal % 2 == 0:
			if alternator:
				selfSprite.position = spritePos - Vector2(1,0)
			else:
				selfSprite.position = spritePos + Vector2(1,0)
			alternator = !alternator
		if timerVal > 100:
			selfSprite.position = spritePos
			isFalling = true
			beginFalling = false
			timerVal = 0
		return
	if isFalling:
		timerVal += 1
		self.position += Vector2(0,fallspeed)
		physicalBody.position += Vector2(0,fallspeed)
		collisionBody.position += Vector2(0,fallspeed)
		fallspeed += fallAcceleration
	if timerVal > 300:
		self.position = originalPosition
		physicalBody.position = physicalBodyOriginalPosition
		collisionBody.position = collisionBodyOriginalPosition
		isFalling = false
		timerVal = 0
		fallspeed = originalFallSpeed

func _on_area_2d_area_entered(area: Area2D) -> void:
	if playerCharacter and playerCharacter.is_on_floor():
		beginFalling = true
