extends Node

class_name SignalBus

signal PlayerCanInteract(InteractableObject:String,IsTrue:bool)

signal PlayerInteractPressed(InteractableObject:String)

signal togglePlayerInput(inputAllowed:bool)

signal updateInventory()

signal collectItem(item: InvItem)

signal updateItem(item_old: InvItem, item_new: InvItem)

signal sendQuestDesc(name: String, desc: String)

signal toggleNotebookInput(input: bool)

signal toggleInventoryInput(input: bool)

signal respawnPlayer()

signal damagePlayer(damage: int, objectVelocity: Vector2)

signal updatePlayerHealth(health: int)

signal testSignal(message: String)

signal toggleAsset(assetName: String, toggled: bool)

signal updateDialogueStart(startingPoint: String)

signal updateInfoAnimation(infoType: String)

signal unlockSpiritSight()

signal toggleArea(areaName: String, toggled: bool)

signal changeDialoguePoint(characterName: String, newstartingPoint: String)

signal moveCharacter(charName: String, event: String)

signal openDoor(doorName: String, animateName: String)

signal updateInteractText(interactName: String, newtooltip: String)

signal forceJump(newVelocity: float)

signal changePlayerVelocity(newVelocity: float)

signal returnToOriginalVelocity()

signal transitionToPlatforming()

signal shakeCam(toggle: bool)

signal playBGM(sceneName: String)

signal animateScreenWipe(animationName: String)
