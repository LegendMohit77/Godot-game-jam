extends Area2D
@export var next_level: String ="res://Scenes/Level2.tscn"

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
	

func _on_body_entered(body:CharacterBody2D) -> void:
	
		animated_sprite.play("Open")
		
		await animated_sprite.animation_finished
		get_tree().paused=true
		await get_tree().create_timer(0.5).timeout
		get_tree().paused=false
		get_tree().change_scene_to_file(next_level)
