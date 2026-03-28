extends CharacterBody2D

const speed = 150.0
@export var jump_velocity = -200.0	
var tempVelocity = -200.0


@export var inventory: Inv

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var canInteract = false
var interactable = ""
var inputDisabled = false
var spiritSightOn = true
var direction: Vector2
var hasStopped = true
var playerHealth : int = 10
var tempInputDisable = false
var canWalljump = true

@onready var movement_state_machine = $Animations/AnimationTree.get("parameters/MovementStateMachine/playback")
@onready var domain_expansion = $DomainExpansion/AnimationPlayer
@onready var hitflash = $HitFlashAnimationPlayer
@onready var PlayerUI = $"../PlayerUI"
@onready var walkingSFX = $WalkAudio
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("Player")
	Signals.PlayerCanInteract.connect(Callable(self,"ChangeInteractionStatus"))
	Signals.unlockSpiritSight.connect(Callable(self,"SeeTheThings"))
	Signals.moveCharacter.connect(Callable(self,"moveBody"))
	DialogueManager.dialogue_started.connect(Callable(self,"disableInput"))
	DialogueManager.dialogue_ended.connect(Callable(self,"enableInput"))
	Signals.togglePlayerInput.connect(Callable(self,"toggleInput"))
	Signals.damagePlayer.connect(Callable(self,"takeDamage"))
	Signals.changePlayerVelocity.connect(Callable(self,"tempChangeVelocity"))
	Signals.returnToOriginalVelocity.connect(Callable(self,"returnToOriginalVelocity"))
	if sceneManager.player_pos:
		global_position = sceneManager.player_pos
	inventory.makeReady()

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		move_and_slide()
	
	if Input.is_action_just_pressed("Fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

	#Do not continue if we do not allow input for the player
	if inputDisabled:
		return
		
	if Input.is_action_just_pressed("PauseMenu"):
		print("am i paused?")
		PlayerUI.UIAnimation.play("pause_move")
		get_tree().paused = true

	if Input.is_action_just_pressed("Spirit Sight") && Global.hasunlockedSight == true:
		#spiritSightOn = !spiritSightOn
		Signals.PlayerInteractPressed.emit("ShowSpirit")
		print("Spirit Sight = ", spiritSightOn)
		domain_expansion.play("spirit_sense")
		if Global.spiritTutorial == false:
			Global.spiritTutorial = true
			await domain_expansion.animation_finished
			Signals.updateInfoAnimation.emit("spiritdone")
			tempInputDisable = false
	
	if tempInputDisable:
		return
	#interact
	if canInteract and is_on_floor() and Input.is_action_just_pressed("Interact"):
		#disableInput(true)
		Signals.PlayerInteractPressed.emit(interactable)
	#jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	
	var direction = Input.get_axis("move_left", "move_right")
	
	#walljump
	if Input.is_action_just_pressed("jump") and is_on_wall_only() and canWalljump:
		velocity.y = jump_velocity
		canWalljump = false
			
	#print(direction)
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x,0, speed)
	
	animate(direction)
	if is_on_floor():
		move_and_slide()
		canWalljump = true
	get_basic_input()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func ChangeInteractionStatus(InteractableObject:String,IsTrue:bool):
	canInteract = IsTrue
	interactable = InteractableObject

func toggleInput(toggle: bool):
	#true
	if toggle:
		enableInput(true)
		Signals.updateInfoAnimation.emit("showTips")
	else:
		disableInput(false)
		Signals.updateInfoAnimation.emit("hideTips")


func disableInput(resource):
	inputDisabled = true
	Signals.updateInfoAnimation.emit("hideTips")
	movement_state_machine.travel("IdleSet")

func enableInput(resource):
	inputDisabled = false
	Signals.updateInfoAnimation.emit("showTips")

#ANIMATIONTREE CONTROLLLLLLL
func animate(direction):
	if direction:
		$Animations/AnimationTree.set("parameters/MovementStateMachine/JumpSet/blend_position", Vector2(direction,0))
		$Animations/AnimationTree.set("parameters/MovementStateMachine/FallSet/blend_position", Vector2(direction,0))
		if is_on_floor():
			movement_state_machine.travel("RunSet")
			#if walkingSFX.playing != true:
				#walkingSFX.pitch_scale = randf_range(0.9,1.1)
				#walkingSFX.play()
			$Animations/AnimationTree.set("parameters/MovementStateMachine/RunSet/blend_position", Vector2(direction,0))
			$Animations/AnimationTree.set("parameters/MovementStateMachine/IdleSet/blend_position", Vector2(direction,0))
			$Animations/AnimationTree.set("parameters/WindupSpace/blend_position",Vector2(direction,0))
			$Animations/AnimationTree.set("parameters/EaseOutSpace/blend_position",Vector2(direction,0))
		#elif not is_on_floor() && velocity.y > 0:
			#movement_state_machine.travel("JumpSet")
		elif not is_on_floor() && velocity.y < 10:
			movement_state_machine.travel("FallSet")
	else:
		if is_on_floor():
			movement_state_machine.travel("IdleSet")
			if hasStopped != true && Input.is_action_just_pressed("move_left") or hasStopped != true && Input.is_action_just_pressed("move_right"):
				$Animations/AnimationTree.set("parameters/animation_tween/blend_amount", 1)
				$Animations/AnimationTree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
				await $Animations/AnimationTree.animation_finished
			hasStopped = true
		#elif not is_on_floor() && velocity.y > 0:
			#movement_state_machine.travel("JumpSet")
		elif not is_on_floor():
			movement_state_machine.travel("FallSet")
	#Added for redundancy
	if inputDisabled == true:
		movement_state_machine.travel("IdleSet")

func get_basic_input():
	if hasStopped == true && Input.is_action_just_pressed("move_left") or hasStopped == true && Input.is_action_just_pressed("move_right"):
		$Animations/AnimationTree.set("parameters/animation_tween/blend_amount", 0)
		$Animations/AnimationTree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		hasStopped = false

func takeDamage(damage: int, objectVelocity: Vector2):
	playerHealth -= damage
	var knockback = (objectVelocity - velocity).normalized() * 500
	velocity.x = knockback.x
	velocity.y -= 150
	move_and_slide()
	hitflash.play("hitflash")
	if playerHealth <= 0:
		print("player should be dead")
		Signals.reloadScene.emit()
	Signals.updatePlayerHealth.emit(playerHealth)
	return
	
func SeeTheThings():
	Global.hasunlockedSight = true
	tempInputDisable = true
	movement_state_machine.travel("IdleSet")
	
func moveBody(charName: String, event: String):
	if charName == self.name:
		if event == "exitStore":
			print("im movin")
			$Animations/AnimationTree.set("parameters/MovementStateMachine/IdleSet/blend_position", Vector2(-1,0))
		elif event == "chaseShu":
			$Animations/AnimationTree.set("parameters/MovementStateMachine/RunSet/blend_position", Vector2(1,0))
			movement_state_machine.travel("RunSet")
			print("im chasin")
			var tween = create_tween()
			tween.set_ease(Tween.EASE_OUT)
			tween.set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(self, "position", Vector2(2325.0,165), 2)
			await get_tree().create_timer(0.8).timeout
			$Animations/AnimationTree.set("parameters/MovementStateMachine/IdleSet/blend_position", Vector2(1,0))
			$Animations/AnimationTree.set("parameters/animation_tween/blend_amount", 1)
			$Animations/AnimationTree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
			movement_state_machine.travel("IdleSet")
		elif event == "Office":
			self.position = Vector2(315,250)
			$Animations/AnimationTree.set("parameters/MovementStateMachine/IdleSet/blend_position", Vector2(-1,0))
		elif event == "beans":
			movement_state_machine.travel("beans")
			await $Animations/AnimationTree.animation_finished
			movement_state_machine.travel("IdleSet")
		elif event == "box":
			movement_state_machine.travel("box")
			await $Animations/AnimationTree.animation_finished
			movement_state_machine.travel("box_idle")
		elif event == "box_idle":
			movement_state_machine.travel("box_idle")

			
func tempChangeVelocity(newVelocity: float):
	tempVelocity = jump_velocity
	jump_velocity = newVelocity
	pass
	
func returnToOriginalVelocity():
	jump_velocity = tempVelocity
