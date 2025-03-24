extends Node2D


# Called when the node enters the scene tree for the first time.
func _process(delta: float) -> void:
	if Input.is_action_pressed("start"):
		get_tree().change_scene_to_file("res://Scenes/Level1.tscn")
