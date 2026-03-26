extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.oneshot_assets.has(self.name):
		queue_free()
	pass # Replace with function body.

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("oh yeah")
		if self.name == "YokaiShuOneShot":
			DialogueManager.show_dialogue_balloon_scene(load("res://Scenes/DialogueBalloons/balloon.tscn"), load("res://Assets/Dialogue/Shu.dialogue"), "yokaiShuFound", )
			Global.oneshot_assets[self.name] = true
			self.queue_free()
		elif self.name == "YokaiShuOneShot2":
			DialogueManager.show_dialogue_balloon_scene(load("res://Scenes/DialogueBalloons/balloon.tscn"), load("res://Assets/Dialogue/Shu.dialogue"), "yokaiRealmShuConfrontation2", )
			Global.oneshot_assets[self.name] = true
			self.queue_free()
		elif self.name == "AlleywayOneShot":
			Global.questsList.quests.append(load("res://Assets/Quests/Quest7.tres"))
			Global.markPreviousQuest(load("res://Assets/Quests/Quest6.tres"))
			Signals.updateInfoAnimation.emit("notebook")
			Global.oneshot_assets[self.name] = true
			self.queue_free()
	pass # Replace with function body.
