extends Node

var time_left: float = 90.0  # Set initial time
var running: bool = true  # Controls whether the timer is active

func _process(delta):
	if running:
		time_left -= delta  # Decrease time every frame
		if time_left <= 0:
			time_left = 0
			running = false  # Stop the timer
			on_timer_end()  # Call the function when time runs out

func on_timer_end():
	get_tree().paused = true
	await get_tree().create_timer(0.5).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/retry_screen.tscn")

func reset_timer():
	time_left = 90.0  # Reset time (if needed)
	running = true

func add_time(amount: float):
	time_left += amount  # Add extra time when collecting pickups
