class_name NPC_Notebook_Profile
extends Resource

@export var name: String
@export var evidenceQuotes: PackedStringArray

func _init(n = "", q = []):
	name = n
	evidenceQuotes = q
