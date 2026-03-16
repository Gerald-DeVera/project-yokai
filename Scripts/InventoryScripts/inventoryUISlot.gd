extends Panel

@onready var itemVisual: Sprite2D = $CenterContainer/Panel/itemDisplay
@onready var indicator: Sprite2D = $InventoryItemindic
@onready var itemContainer: Sprite2D = $Sprite2D
@onready var slotPlayer: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	return
	

func update(item: InvItem):
	if not item:
		itemVisual.visible = false
	else:
		itemVisual.visible = true
		itemVisual.texture = item.texture
		itemContainer.frame = 1
		
func showActive():
	indicator.visible = true
	slotPlayer.play("focus_in")
	
func hideActive():
	indicator.visible = false
	slotPlayer.play_backwards("focus_in")
