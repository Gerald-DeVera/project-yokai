extends CanvasLayer

@onready var InventoryAnimation = $AnimationPlayer
@onready var PauseMenu = $HUD/PauseMenu
@onready var Notebook = $HUD/Notebook

func _ready() -> void:
	PauseMenu.visible = false
	Notebook.visible = false

func _on_inventory_ui_inventory_close():
	InventoryAnimation.play_backwards("move")

func _on_inventory_ui_inventory_open():
	InventoryAnimation.play("move")

func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	PauseMenu.visible = false

func _on_quit_button_pressed() -> void:
	get_tree().quit()
