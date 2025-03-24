extends Node

@onready var timer_label := $Label  # Reference to the label

func _process(delta):
	timer_label.text = "Time: " + str(ceil(TimerManager.time_left))  # Display time from TimerManager
