extends Area2D

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):  
		AudioManager.hurt.play()

		GlobalVars.deaths += 1  # Increase death count

		get_tree().paused = true
		var camera = get_tree().root.find_child("Camera2D", true, false)
		
		if camera:
			shake_camera(camera, 2, 0.3)  # Shake effect
		await get_tree().create_timer(0.3).timeout
		get_tree().paused = false

		get_tree().reload_current_scene()  # Reload the level

func shake_camera(camera: Camera2D, intensity: float, duration: float):
	var timer := get_tree().create_timer(duration)
	while timer.time_left > 0:
		var random_offset = Vector2(
			randf_range(-intensity, intensity),
			randf_range(-intensity, intensity)
		)
		camera.offset = random_offset
		await get_tree().process_frame

	camera.offset = Vector2.ZERO  # Reset camera position
