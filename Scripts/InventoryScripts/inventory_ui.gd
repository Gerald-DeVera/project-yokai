extends Control

@onready var inv: Inv = preload("res://Assets/InventoryItems/playerInventory.tres")
@onready var gridExist = $NinePatchRect/GridContainer

var slots: Array
var curSlotIndex: int = 0
var is_open = false
var inputDisabled = false

func _ready() -> void:
	if gridExist:
		slots = gridExist.get_children()
		updateSlots()
	else:
		print("no exist")
	close()
	Signals.updateInventory.connect(Callable(self,"updateSlots"))
	DialogueManager.dialogue_started.connect(Callable(self,"disableInput"))
	DialogueManager.dialogue_ended.connect(Callable(self,"enableInput"))
	return

func updateSlots():
	for i in range(min(inv.items.size(), slots.size())):
		slots[i].update(inv.items[i])

func enableInput(resource):
	inputDisabled = false

func disableInput(resource):
	inputDisabled = true

func _process(delta: float) -> void:
	if inputDisabled:
		return
	
	if Input.is_action_just_pressed("inventory"):
		if is_open:
			close()
		else:
			open()
			curSlotIndex = 0

	if is_open:
		if Input.is_action_just_pressed("move_left") and curSlotIndex > 0:
			curSlotIndex -= 1
			if(inv.items[curSlotIndex]):
				print("item: ", inv.items[curSlotIndex].name, " item description: ", inv.items[curSlotIndex].description)
		elif Input.is_action_just_pressed("move_right") and curSlotIndex < min(inv.items.size(), slots.size()) - 1:
			curSlotIndex += 1
			if(inv.items[curSlotIndex]):
				print("item: ", inv.items[curSlotIndex].name, " item description: ", inv.items[curSlotIndex].description)
		
#		if inv.items[curSlotIndex]:
		#slots[curSlotIndex]
		
		#print("thjig")
  
func close():
	visible = false
	is_open = false
	Signals.togglePlayerInput.emit(true)
	
func open():
	self.visible = true
	is_open = true	
	Signals.togglePlayerInput.emit(false)
