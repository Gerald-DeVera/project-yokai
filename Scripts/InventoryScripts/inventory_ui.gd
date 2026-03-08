extends Control

@onready var inv: Inv = preload("res://Assets/InventoryItems/playerInventory.tres")
@onready var gridExist = $NinePatchRect/GridContainer

var slots: Array

var is_open = false

func _ready() -> void:
	if gridExist:
		slots = gridExist.get_children()
		updateSlots()
	else:
		print("no exist")
	close()
	Signals.updateInventory.connect(Callable(self,"updateSlots"))
	return

func updateSlots():
	for i in range(min(inv.items.size(), slots.size())):
		slots[i].update(inv.items[i])

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		if is_open:
			close()
		else:
			open()
  
func close():
	visible = false
	is_open = false
	
func open():
	self.visible = true
	is_open = true	
