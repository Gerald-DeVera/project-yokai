extends Resource

class_name NPC_Profiles

@export var profileInfo: Array[NPC_Profile]

func insert(p: NPC_Profile):
	profileInfo.push_back(p)
