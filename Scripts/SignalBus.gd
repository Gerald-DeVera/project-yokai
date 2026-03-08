extends Node

class_name SignalBus

signal PlayerCanInteract(InteractableObject:String,IsTrue:bool)

signal PlayerInteractPressed(InteractableObject:String)

signal updateInventory()

signal collectItem(item: InvItem)
