extends Node

var player_pos: Vector2
#foundQuests (should) consist of the string key/value pairs where the keys are quest names and
#values are their descriptions
var foundQuests: Dictionary
#foundQuotes (should) do the same, but with keys being NPC names and values being the quotes
var foundQuotes: Dictionary
#This should help with better sorting of the Notebook in theory
