extends Node

@onready var timer := $Timer
@onready var timer_label := $Label

func _process(delta):
	timer_label.text = "Time: " + str(ceil(timer.time_left))  # Update UI

func _on_timer_timeout() -> void:
		get_tree().paused=true
		await get_tree().create_timer(0.5).timeout
		get_tree().paused=false
		get_tree().reload_current_scene()  # Reload scene when time runs out
