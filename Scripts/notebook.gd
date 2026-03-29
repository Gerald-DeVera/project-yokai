extends Control

var runOnce = true
var pageNumber
var MAX_PAGES = 5
var questEntryTemplate = preload("res://Scenes/UIandUtil/quest_entry.tscn")
var inputDisabled = false

@onready var pageTitle = $Main/TitleLeft
@onready var questPage = $Main/QuestPage
@onready var profilePages = $Main/ProfilePages
@onready var questTitle = $Main/QuestPage/TitleRight
@onready var questEntries = $Main/QuestPage/ScrollContainerLeft/QuestEntries
@onready var currentQuestDesc = $Main/QuestPage/ScrollContainerRight/VBoxContainer/QuestDescription
@onready var notebookAnimate = $AnimationPlayer
@onready var backKey = $Back
@onready var forwardKey = $Forward

@onready var npcBio = $Main/ProfilePages/Bio
@onready var profileSprite = $Main/ProfilePages/ProfilePicture
@onready var npcInfo = $Main/ProfilePages/Info_Quotes

@onready var flipSound = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.sendQuestDesc.connect(Callable(self, "displayQuestDesc"))
	Signals.toggleNotebookInput.connect(Callable(self, "toggleNotebookInput"))
	DialogueManager.dialogue_started.connect(Callable(self,"disableInput"))
	DialogueManager.dialogue_ended.connect(Callable(self,"enableInput"))

func setup() -> void:
	pageNumber = 1
	flipToPage(pageNumber)
	forwardKey.visible = true
	backKey.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Notebook") and visible == true:
		Signals.togglePlayerInput.emit(true)
		Signals.toggleInventoryInput.emit(false)
		notebookAnimate.play_backwards("toggle")
		await notebookAnimate.animation_finished
		visible = false
		return
	if inputDisabled:
		return
	
	if Input.is_action_just_pressed("Notebook") and visible == false:
		notebookAnimate.play("RESET")
		await notebookAnimate.animation_finished
		visible = true
		notebookAnimate.play("toggle")
		Signals.togglePlayerInput.emit(false)
		Signals.toggleInventoryInput.emit(true)
		setup()
	

func toggleNotebookInput(input: bool):
	inputDisabled = input

func enableInput(resource):
	inputDisabled = false

func disableInput(resource):
	inputDisabled = true

#This implementation really depends on how much evidence there ends up being
func flipToPage(page:int) -> void:
	questPage.visible = false
	profilePages.visible = false
	
	pageTitle.set_text("")
	questTitle.set_text("")
	currentQuestDesc.set_text("")
	npcBio.set_text("")
	npcInfo.set_text("")
	
	for q in questEntries.get_children():
		q.queue_free()
	match(page):
		1:	
			pageTitle.set_text("Investigation Progress")
			questPage.visible = true
			var newQuestEntry
			for q in range(Global.questsList.quests.size() - 1, -1, -1):
				if q == Global.questsList.quests.size() - 1:
					displayQuestDesc(Global.questsList.quests[q].questName,Global.questsList.quests[q].fullDescription)
				newQuestEntry = questEntryTemplate.instantiate()
				newQuestEntry._ready()
				newQuestEntry.questButton.text = Global.questsList.quests[q].questName
				newQuestEntry.isCompleted = Global.questsList.quests[q].completionStatus
				newQuestEntry.questDescription = Global.questsList.quests[q].fullDescription
				questEntries.add_child(newQuestEntry)
		_:
			profilePages.visible = true
			var profile = Global.npcProfileList.profileInfo[page - 2]
			pageTitle.set_text(profile.name)
			profileSprite.texture = load(profile.profilePicPath)
			npcBio.set_text(profile.bio)
			for q in profile.evidenceQuotes:
				npcInfo.add_text("• " + q + "\n")
	

func _on_back_pressed() -> void:
	if pageNumber > 1:
		forwardKey.visible = true
		pageNumber -= 1
		flipToPage(pageNumber)
		notebookAnimate.play("jiggle_left")
		flipSound.pitch_scale = randf_range(0.9,1.1)
		flipSound.play()
		if pageNumber == 1:
			backKey.visible = false

func _on_forward_pressed() -> void:
	if pageNumber < Global.npcProfileList.profileInfo.size() + 1:
		backKey.visible = true
		pageNumber += 1
		flipToPage(pageNumber)
		notebookAnimate.play("jiggle_right")
		flipSound.pitch_scale = randf_range(0.9,1.1)
		flipSound.play()
		if pageNumber == Global.npcProfileList.profileInfo.size() + 1:
			forwardKey.visible = false

		


func displayQuestDesc(name, desc) -> void:
	currentQuestDesc.set_text(desc)
	questTitle.set_text(name)
	print("Signal Received")
