extends Control

@onready var inv: Inv = preload("res://Assets/InventoryItems/playerInventory.tres")
@onready var gridExist = $NinePatchRect/GridContainer
@onready var itemNameLabel = $Control/ItemName
@onready var itemDescription = $Control/ItemDesc
@onready var imageSwap = $Control/AnimationPlayer
@onready var nextImage = $Control/PolLeft/NextImage
@onready var currentImage = $Control/ItemImageDisplay/CurrentImage
@onready var selectSound = $AudioStreamPlayer

signal inventoryClose
signal inventoryOpen

var slots: Array
var curSlotIndex: int = 0
var is_open = false
var inputDisabled = true
var numRows = 3

func _ready() -> void:
	if gridExist:
		slots = gridExist.get_children()
		updateSlots()
	else:
		print("no exist")
	close()
	Signals.updateInventory.connect(Callable(self,"updateSlots"))
	Signals.toggleInventoryInput.connect(Callable(self, "toggleInventoryInput"))
	DialogueManager.dialogue_started.connect(Callable(self,"disableInput"))
	DialogueManager.dialogue_ended.connect(Callable(self,"enableInput"))
	return

func updateSlots():
	for i in range(min(inv.items.size(), slots.size())):
		slots[i].update(inv.items[i])

func toggleInventoryInput(input: bool):
	inputDisabled = input

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
			Signals.toggleNotebookInput.emit(true)
			Signals.toggleEscapeInput.emit(true)

	if is_open:
		if Input.is_action_just_pressed("move_left"):
			selectSound.play()
			var prevSlot = curSlotIndex
			if curSlotIndex == 0:
				curSlotIndex = slots.size()-1
			else:
				curSlotIndex -= 1
			itemAnimation(prevSlot)
		elif Input.is_action_just_pressed("move_right"):
			selectSound.play()
			var prevSlot = curSlotIndex
			if curSlotIndex == slots.size()-1:
				curSlotIndex = 0
			else:
				curSlotIndex += 1
			itemAnimation(prevSlot)
		elif Input.is_action_just_pressed("move_down"):
			selectSound.play()
			var prevSlot = curSlotIndex
			curSlotIndex += int((slots.size()/numRows))
			curSlotIndex = curSlotIndex % slots.size()
			itemAnimation(prevSlot)
		elif Input.is_action_just_pressed("move_up"):
			selectSound.play()
			var prevSlot = curSlotIndex
			if curSlotIndex > 3:
				curSlotIndex -= int(slots.size()/numRows)
			else: #curSlotIndex  is 0, 1, 2, 3, i.e. first row
				curSlotIndex += slots.size() - int(slots.size()/numRows)
			curSlotIndex = curSlotIndex % slots.size()
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
		nextImage.texture = inv.items[curSlotIndex].closeup_texture
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
	nextImage.texture = inv.items[0].closeup_texture
	#self.visible = true
	is_open = true	
	Signals.togglePlayerInput.emit(false)
