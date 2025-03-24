extends Node2D

@onready var label = $Label  # Make sure you have a Label node in the scene

func _ready():
	label.text = "Deaths: " + str(GlobalVars.deaths)
