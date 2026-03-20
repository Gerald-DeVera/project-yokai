extends Resource

class_name NPC_Profile

@export var name: String
@export var profilePicPath: String
@export var bio: String
@export var evidenceQuotes: PackedStringArray

func _init(n = "", pfp = "res://Assets/Sprites/placeholderDefaultPFP.png", b = "", q = []):
	name = n
	profilePicPath = pfp
	bio = b
	evidenceQuotes = q
