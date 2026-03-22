extends Node

class_name SignalBus

signal PlayerCanInteract(InteractableObject:String,IsTrue:bool)

signal PlayerInteractPressed(InteractableObject:String)

signal togglePlayerInput(inputAllowed:bool)

signal updateInventory()

signal collectItem(item: InvItem)

signal sendQuestDesc(name: String, desc: String)

signal toggleNotebookInput(input: bool)

signal toggleInventoryInput(input: bool)

signal toggleAsset(assetName: String, toggled: bool)

signal updateDialogueStart(startingPoint: String)

signal updateInfoAnimation(infoType: String)

signal unlockSpiritSight()

signal toggleArea(areaName: String, toggled: bool)

signal changeDialoguePoint(characterName: String, newstartingPoint: String)
