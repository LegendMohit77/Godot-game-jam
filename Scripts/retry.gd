extends Button

func _pressed() -> void:
	TimerManager.reset_timer()
	get_tree().change_scene_to_file("res://Scenes/Level1.tscn")
