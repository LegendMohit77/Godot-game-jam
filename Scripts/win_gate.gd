extends Area2D
@export var next_level: String ="res://Scenes/testlevel.tscn"



	

func _on_body_entered(body:CharacterBody2D) -> void:
		get_tree().change_scene_to_file(next_level)
