extends Control

var runOnce = true
var pageNumber
var MAX_PAGES = 2
var questEntryTemplate = preload("res://Scenes/UIandUtil/quest_entry.tscn")

@onready var pageTitle = $TitleLeft
@onready var questPage = $QuestPage
@onready var profilePages = $ProfilePages
@onready var questTitle = $QuestPage/TitleRight
@onready var questEntries = $QuestPage/ScrollContainerLeft/QuestEntries
@onready var currentQuestDesc = $QuestPage/ScrollContainerRight/VBoxContainer/QuestDescription

@onready var npcBio = $ProfilePages/Bio
@onready var profileSprite = $ProfilePages/ProfilePicture
@onready var npcInfo = $ProfilePages/Info_Quotes

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.sendQuestDesc.connect(Callable(self, "displayQuestDesc"))

func setup() -> void:
	pageNumber = 1
	flipToPage(pageNumber)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !visible:
		runOnce = true
		return

	if visible and runOnce:
		runOnce = false
		setup()
		Signals.togglePlayerInput.emit(false)
		return
	
	if Input.is_action_just_pressed("Notebook"):
		visible = false
		Signals.togglePlayerInput.emit(true)
	

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
			for q in Global.questsList.quests.size():
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
				npcInfo.add_text("- " + q + "\n")
	

func _on_back_pressed() -> void:
	if pageNumber > 1:
		pageNumber -= 1
		flipToPage(pageNumber)

func _on_forward_pressed() -> void:
	if pageNumber < Global.npcProfileList.profileInfo.size() + 1:
		pageNumber += 1
		flipToPage(pageNumber)

func displayQuestDesc(name, desc) -> void:
	currentQuestDesc.set_text(desc)
	questTitle.set_text(name)
	print("Signal Received")
