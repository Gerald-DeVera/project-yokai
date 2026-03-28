extends Resource

class_name Inv

@export var items: Array[InvItem]

func _ready() -> void:
	return

func makeReady():
	Signals.collectItem.connect(Callable(self, "insert"))
	Signals.updateItem.connect(Callable(self, "update"))

func insert(item: InvItem):
	for index in items.size():
		if items[index] == null:
			items[index] = item
			Signals.updateInventory.emit()
			return
		else:
			continue

func update(item_old: InvItem, item_new: InvItem):
	var index = items.find(item_old)
	items[index] = item_new
