extends CanvasLayer

@onready var UIAnimation = $AnimationPlayer
@onready var PauseMenu = $HUD/PauseMenu
@onready var Notebook = $HUD/Notebook

func _ready() -> void:
	PauseMenu.visible = false
	Notebook.visible = false

func _on_inventory_ui_inventory_close():
	UIAnimation.play_backwards("move")

func _on_inventory_ui_inventory_open():
	UIAnimation.play("move")

func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	UIAnimation.play_backwards("pause_move")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
