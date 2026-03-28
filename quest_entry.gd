extends Control

@export var isCompleted: bool = false
@onready var questDescription : String
@onready var checkmark = $checkSprite
@onready var questButton = $Button
var checkedSprite = load("res://Assets/Sprites/checked.png")
var uncheckedSprite = load("res://Assets/Sprites/unchecked.png")

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if !visible:
		return
	if isCompleted:
		checkmark.texture = checkedSprite
	else:
		checkmark.texture = uncheckedSprite
	
func setText(txt: String):
	questButton.text = txt
	
func _on_button_pressed() -> void:
	Signals.sendQuestDesc.emit(questButton.text, questDescription)
	print("Signal Sent")
