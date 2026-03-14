extends Control

var runOnce = true
var pageNumber
var MAX_PAGES = 2

@onready var leftPage = $Page3/RichTextLabel
@onready var rightPage = $Page4/RichTextLabel2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

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
		return
	
	if Input.is_action_just_pressed("Notebook"):
		visible = false
	

#This implementation really depends on how much evidence there ends up being
func flipToPage(page:int) -> void:
	leftPage.clear()
	rightPage.clear()
	match(page):
		1:
			pass
			for quest in Global.foundQuests:
				leftPage.add_text(quest.questName + "\n" + quest.fullDescription)
				
		2:
			pass
	

func _on_back_pressed() -> void:
	if pageNumber > 1:
		pageNumber -= 1
		flipToPage(pageNumber)

func _on_forward_pressed() -> void:
	if pageNumber < MAX_PAGES:
		pageNumber += 1
		flipToPage(pageNumber)
