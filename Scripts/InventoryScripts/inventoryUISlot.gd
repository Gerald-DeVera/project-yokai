extends Panel

@onready var itemVisual: Sprite2D = $CenterContainer/Panel/itemDisplay
@onready var indicator: Sprite2D = $InventoryItemindic
@onready var itemContainer: Sprite2D = $Sprite2D

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
	
func hideActive():
	indicator.visible = false
