extends Area2D

@export var time_bonus: float = 5.0  # Time to add when collected

func _on_body_entered(body):
	if body.is_in_group("player"):  # Ensure only the player collects it
		TimerManager.add_time(time_bonus)  # Increase the timer
		queue_free()  # Remove pickup
