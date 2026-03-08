extends Resource

class_name Inv

@export var items: Array[InvItem]

func _ready() -> void:
	return

func makeReady():
	Signals.collectItem.connect(Callable(self, "insert"))

func insert(item: InvItem):
	for index in items.size():
		if items[index] == null:
			items[index] = item
			Signals.updateInventory.emit()
			return
		else:
			continue
	
		
