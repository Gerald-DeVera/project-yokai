extends CanvasLayer
## A basic dialogue balloon for use with Dialogue Manager.

## DIALOGUE STATE ENUM
enum dialogueStates {
	neutral = 0,
	happy = 1,
	angry = 2,
	confused = 3,
	unimp = 4
}
#CAMERA CONTROL REFERENCE IN SCENE
@onready var CameraControl = $"../AnimationPlayer"

## The dialogue resource
@export var dialogue_resource: DialogueResource

## Start from a given title when using balloon as a [Node] in a scene.
@export var start_from_title: String = ""

## If running as a [Node] in a scene then auto start the dialogue.
@export var auto_start: bool = false

## If all other input is blocked as long as dialogue is shown.
@export var will_block_other_input: bool = true

## The action to use for advancing the dialogue
@export var next_action: StringName = &"ui_accept"

## The action to use to skip typing the dialogue
@export var skip_action: StringName = &"ui_cancel"

## A sound player for voice lines (if they exist).
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer

## ADDED SPRITE 1 FOR MC
@onready var char_sprite_left: Sprite2D = %Sprite2DLeft
@onready var animate_left: AnimationPlayer = %Sprite2DLeft/AnimationPlayer

## SPRITE FOR 2ND SPEAKER
@onready var char_sprite_right: Sprite2D = %Sprite2DRight
@onready var animate_right: AnimationPlayer = %Sprite2DRight/AnimationPlayer

##PRELOAD SPEAKER TEXTURES
var yumi_texture = preload("res://Assets/Sprites/yumi expressions.png")
var ina_texture = preload("res://Assets/Sprites/ina expressions.png")
var sagawa_texture = preload("res://Assets/Sprites/ramen dad expressions.png")
var kite_texture_left = preload("res://Assets/Sprites/kite expressions left.png")
var kite_texture_right = preload("res://Assets/Sprites/kite expressions right.png")
var yui_texture = preload("res://Assets/Sprites/yui expressions.png")
var shu_texture = preload("res://Assets/Sprites/shu expressions.png")
var makoto_texture = preload("res://Assets/Sprites/mc_expressions.png")
var oldguy_texture = preload("res://Assets/Sprites/old guy expressions.png")
var athwoman_texture = preload("res://Assets/Sprites/athletic lady expressions.png")
var clothier_texture = preload("res://Assets/Sprites/clothier expressions.png")
var yui_texture_left = preload("res://Assets/Sprites/yui expressions left.png")
var kijo_texture = preload("res://Assets/Sprites/kijo expression.png")


## Temporary game states
var temporary_game_states: Array = []

## See if we are waiting for the player
var is_waiting_for_input: bool = false

## See if we are running a long mutation and should hide the balloon
var will_hide_balloon: bool = false

## A dictionary to store any ephemeral variables
var locals: Dictionary = {}

var _locale: String = TranslationServer.get_locale()

## The current line
var dialogue_line: DialogueLine:
	set(value):
		if value:
			dialogue_line = value
			apply_dialogue_line()
		else:
			# The dialogue has finished so close the balloon
			if owner == null:
				queue_free()
			else:
				hide()
	get:
		return dialogue_line

## A cooldown timer for delaying the balloon hide when encountering a mutation.
var mutation_cooldown: Timer = Timer.new()

## The base balloon anchor
@onready var balloon: Control = %Balloon

## The label showing the name of the currently speaking character
@onready var character_label: RichTextLabel = %CharacterLabel

## The label showing the currently spoken dialogue
@onready var dialogue_label: DialogueLabel = %DialogueLabel

## The menu of responses
@onready var responses_menu: DialogueResponsesMenu = %ResponsesMenu

## Indicator to show that player can progress dialogue.
@onready var progress: Sprite2D = %Progress


func _ready() -> void:
	
	balloon.hide()
	Engine.get_singleton("DialogueManager").mutated.connect(_on_mutated)

	# If the responses menu doesn't have a next action set, use this one
	if responses_menu.next_action.is_empty():
		responses_menu.next_action = next_action

	mutation_cooldown.timeout.connect(_on_mutation_cooldown_timeout)
	add_child(mutation_cooldown)

	if auto_start:
		if not is_instance_valid(dialogue_resource):
			assert(false, DMConstants.get_error_message(DMConstants.ERR_MISSING_RESOURCE_FOR_AUTOSTART))
		start()


func _process(delta: float) -> void:
	if is_instance_valid(dialogue_line):
		progress.visible = not dialogue_label.is_typing and dialogue_line.responses.size() == 0 and not dialogue_line.has_tag("voice")


func _unhandled_input(_event: InputEvent) -> void:
	# Only the balloon is allowed to handle input while it's showing
	if will_block_other_input:
		get_viewport().set_input_as_handled()


func _notification(what: int) -> void:
	## Detect a change of locale and update the current dialogue line to show the new language
	if what == NOTIFICATION_TRANSLATION_CHANGED and _locale != TranslationServer.get_locale() and is_instance_valid(dialogue_label):
		_locale = TranslationServer.get_locale()
		var visible_ratio: float = dialogue_label.visible_ratio
		dialogue_line = await dialogue_resource.get_next_dialogue_line(dialogue_line.id)
		if visible_ratio < 1:
			dialogue_label.skip_typing()


## Start some dialogue
func start(with_dialogue_resource: DialogueResource = null, title: String = "", extra_game_states: Array = []) -> void:
	temporary_game_states = [self] + extra_game_states
	is_waiting_for_input = false
	if is_instance_valid(with_dialogue_resource):
		dialogue_resource = with_dialogue_resource
	if not title.is_empty():
		start_from_title = title
	dialogue_line = await dialogue_resource.get_next_dialogue_line(start_from_title, temporary_game_states)
	show()


## Apply any changes to the balloon given a new [DialogueLine].
func apply_dialogue_line() -> void:
	mutation_cooldown.stop()

	progress.hide()
	is_waiting_for_input = false
	balloon.focus_mode = Control.FOCUS_ALL
	balloon.grab_focus()

	character_label.visible = not dialogue_line.character.is_empty()
	character_label.text = tr(dialogue_line.character, "dialogue")

	dialogue_label.hide()
	dialogue_label.dialogue_line = dialogue_line

	responses_menu.hide()
	responses_menu.responses = dialogue_line.responses

	# Show our balloon
	balloon.show()
	will_hide_balloon = false

	dialogue_label.show()
	
	if dialogue_line.has_tag("new_actor"):
		var load_sprite = dialogue_line.get_tag_value("new_actor")
		if load_sprite == "yumi":
			char_sprite_right.texture = yumi_texture
		elif load_sprite == "ina":
			char_sprite_right.texture = ina_texture
		elif load_sprite == "sagawa":
			char_sprite_right.texture = sagawa_texture
		elif load_sprite == "kite_left":
			char_sprite_left.texture = kite_texture_left
		elif load_sprite == "kite_right":
			char_sprite_right.texture = kite_texture_right
		elif load_sprite == "makoto":
			char_sprite_left.texture = makoto_texture
		elif load_sprite == "yui":
			char_sprite_right.texture = yui_texture
		elif load_sprite == "shu":
			char_sprite_right.texture = shu_texture
		elif load_sprite == "oldguy":
			char_sprite_right.texture = oldguy_texture
		elif load_sprite == "athwoman":
			char_sprite_right.texture = athwoman_texture
		elif load_sprite == "clothier":
			char_sprite_right.texture = clothier_texture
		elif load_sprite == "yui_left":
			char_sprite_left.texture = yui_texture_left
		elif load_sprite == "kijo":
			char_sprite_right.texture = kijo_texture





			
	
	#modulate right sprite for now, repeat for left and enable sprite switching
	if dialogue_line.has_tag("actor_right"):
		var show_sprite = dialogue_line.get_tag_value("actor_right")
		if show_sprite == "on":
			char_sprite_right.visible = true
			print("on")
		elif show_sprite == "off":
			char_sprite_right.visible = false
			print("off")
			
	if dialogue_line.has_tag("actor_left"):
		var show_sprite = dialogue_line.get_tag_value("actor_left")
		if show_sprite == "on":
			char_sprite_left.visible = true
			print("on")
		elif show_sprite == "off":
			char_sprite_left.visible = false
			print("off")
			
	#!!!!!! TEMP SPRITE SWITCHING CODE FOR LEFT SPRITE, USES ENUM @ THE TOP
	if dialogue_line.has_tag("expression_left"):
		var expression_mode_left = dialogue_line.get_tag_value("expression_left")
		print(expression_mode_left)
		char_sprite_left.frame = dialogueStates.get(expression_mode_left)
		
	if dialogue_line.has_tag("expression_right"):
		var expression_mode_right = dialogue_line.get_tag_value("expression_right")
		print(expression_mode_right)
		char_sprite_right.frame = dialogueStates.get(expression_mode_right)

	#SPRITE ANIMATIONE FFEECTSSSS
	if dialogue_line.has_tag("animate_left"):
		var animate_mode_left = dialogue_line.get_tag_value("animate_left")
		print(animate_mode_left)
		animate_left.play(str(animate_mode_left))
		
	if dialogue_line.has_tag("animate_right"):
		var animate_mode_right = dialogue_line.get_tag_value("animate_right")
		print(animate_mode_right)
		animate_right.play(str(animate_mode_right))
		
	#!!!!!!!! TEMP CAMERA MOVEMENT SYSTEM
	if dialogue_line.has_tag("camera_animation") && CameraControl != null:
		print(CameraControl)
		var animation_name = dialogue_line.get_tag_value("camera_animation")
		print(animation_name)
		CameraControl.play(str(animation_name))
	
	if not dialogue_line.text.is_empty():
		dialogue_label.type_out()
		await dialogue_label.finished_typing
		
	# Wait for next line
	if dialogue_line.has_tag("voice"):
		audio_stream_player.stream = load(dialogue_line.get_tag_value("voice"))
		audio_stream_player.play()
		await audio_stream_player.finished
		next(dialogue_line.next_id)
	elif dialogue_line.responses.size() > 0:
		balloon.focus_mode = Control.FOCUS_NONE
		responses_menu.show()
	elif dialogue_line.time != "":
		var time: float = dialogue_line.text.length() * 0.02 if dialogue_line.time == "auto" else dialogue_line.time.to_float()
		await get_tree().create_timer(time).timeout
		next(dialogue_line.next_id)
	else:
		is_waiting_for_input = true
		balloon.focus_mode = Control.FOCUS_ALL
		balloon.grab_focus()


## Go to the next line
func next(next_id: String) -> void:
	dialogue_line = await dialogue_resource.get_next_dialogue_line(next_id, temporary_game_states)


#region Signals


func _on_mutation_cooldown_timeout() -> void:
	if will_hide_balloon:
		will_hide_balloon = false
		balloon.hide()


func _on_mutated(_mutation: Dictionary) -> void:
	if not _mutation.is_inline:
		is_waiting_for_input = false
		will_hide_balloon = true
		mutation_cooldown.start(0.1)


func _on_balloon_gui_input(event: InputEvent) -> void:
	# See if we need to skip typing of the dialogue
	if dialogue_label.is_typing:
		var mouse_was_clicked: bool = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed()
		var skip_button_was_pressed: bool = event.is_action_pressed(skip_action)
		if mouse_was_clicked or skip_button_was_pressed:
			get_viewport().set_input_as_handled()
			dialogue_label.skip_typing()
			return

	if not is_waiting_for_input: return
	if dialogue_line.responses.size() > 0: return

	# When there are no response options the balloon itself is the clickable thing
	get_viewport().set_input_as_handled()

	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		next(dialogue_line.next_id)
	elif event.is_action_pressed(next_action) and get_viewport().gui_get_focus_owner() == balloon:
		next(dialogue_line.next_id)


func _on_responses_menu_response_selected(response: DialogueResponse) -> void:
	next(response.next_id)


#endregion


func _on_dialogue_label_spoke(letter, letter_index, speed):
	if not letter in ["."," "]:
		audio_stream_player.pitch_scale = randf_range(1.0,1.2)
		audio_stream_player.play()
