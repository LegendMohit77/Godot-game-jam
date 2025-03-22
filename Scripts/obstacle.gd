extends Area2D

func _on_body_entered(body: CharacterBody2D) -> void:
	get_tree().paused=true
	await get_tree().create_timer(0.5).timeout
	get_tree().paused=false
	get_tree().reload_current_scene()
