extends Resource

class_name QuestsList

@export var quests: Array[QuestItem]

func insert(q: QuestItem):
	quests.push_back(q)
