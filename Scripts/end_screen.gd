extends Node2D

@onready var label = $Label  # Make sure you have a Label node in the scene

func _ready():
	label.text = "Time Taken: " + str(round(GlobalVars.final_time)) + "s" + "\nDeaths: " + str(GlobalVars.deaths)
