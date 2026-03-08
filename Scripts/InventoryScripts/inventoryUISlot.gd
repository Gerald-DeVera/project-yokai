extends Panel

@onready var itemVisual: Sprite2D = $CenterContainer/Panel/itemDisplay

func _ready() -> void:
	return
	

func update(item: InvItem):
	if not item:
		itemVisual.visible = false
	else:
		itemVisual.visible = true
		itemVisual.texture = item.texture
		
