extends Control

@onready var inv: Inv = preload("res://Assets/InventoryItems/playerInventory.tres")
@onready var gridExist = $NinePatchRect/GridContainer
@onready var itemNameLabel = $Control/ItemName
@onready var itemDescription = $Control/ItemDesc
@onready var imageSwap = $Control/AnimationPlayer
@onready var nextImage = $Control/PolLeft/NextImage
@onready var currentImage = $Control/ItemImageDisplay/CurrentImage

signal inventoryClose
signal inventoryOpen

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
			inventoryClose.emit()
			close()
		else:
			inventoryOpen.emit()
			open()
			curSlotIndex = 0

	if is_open:
		if Input.is_action_just_pressed("move_left"):
			var prevSlot = curSlotIndex
			if curSlotIndex == 0:
				curSlotIndex = slots.size()-1
			else:
				curSlotIndex -= 1
			itemAnimation(prevSlot)
		elif Input.is_action_just_pressed("move_right"):
			var prevSlot = curSlotIndex
			if curSlotIndex == slots.size()-1:
				curSlotIndex = 0
			else:
				curSlotIndex += 1
			itemAnimation(prevSlot)


func itemAnimation(prevSlot):
	slots[curSlotIndex].showActive()
	slots[prevSlot].hideActive()
	if(inv.items[curSlotIndex]):
		#print("item: ", inv.items[curSlotIndex].name, " item description: ", inv.items[curSlotIndex].description)
		itemNameLabel.text = inv.items[curSlotIndex].name
		itemDescription.text = inv.items[curSlotIndex].description
		imageSwap.stop()
		#print(inv.items[curSlotIndex].texture)
		currentImage.texture = nextImage.texture
		nextImage.texture = inv.items[curSlotIndex].texture
		#currentImage.texture = inv.items[curSlotIndex+1].texture
		imageSwap.play("change_image")
	return
  
func close():
	slots[curSlotIndex].hideActive()
	#visible = false
	is_open = false
	Signals.togglePlayerInput.emit(true)
	
func open():
	slots[0].showActive()
	nextImage.texture = inv.items[0].texture
	#self.visible = true
	is_open = true	
	Signals.togglePlayerInput.emit(false)
