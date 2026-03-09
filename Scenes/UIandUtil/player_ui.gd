extends CanvasLayer

@onready var InventoryAnimation = $AnimationPlayer


func _ready():
	pass
		
func _on_inventory_ui_inventory_close():
	InventoryAnimation.play_backwards("move")

func _on_inventory_ui_inventory_open():
	InventoryAnimation.play("move")
