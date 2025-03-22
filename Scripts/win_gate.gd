extends Area2D
@export var next_level: String ="res://Scenes/Level1.tscn"

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
<<<<<<< HEAD
<<<<<<< HEAD

=======
>>>>>>> 4cfa4c2de435cfb44390ff6b5faecf4be667b376
=======
>>>>>>> 4cfa4c2de435cfb44390ff6b5faecf4be667b376
	

func _on_body_entered(body:CharacterBody2D) -> void:
	
<<<<<<< HEAD
<<<<<<< HEAD
		animated_sprite.play("win")
		
		
		await animated_sprite.animation_finished  
		get_tree().paused=true
		await get_tree().create_timer(0.3).timeout
		get_tree().paused=false
		
=======
=======
>>>>>>> 4cfa4c2de435cfb44390ff6b5faecf4be667b376
		animated_sprite.play("Open")
		
		await animated_sprite.animation_finished
		get_tree().paused=true
		await get_tree().create_timer(0.5).timeout
		get_tree().paused=false
<<<<<<< HEAD
>>>>>>> 4cfa4c2de435cfb44390ff6b5faecf4be667b376
=======
>>>>>>> 4cfa4c2de435cfb44390ff6b5faecf4be667b376
		get_tree().change_scene_to_file(next_level)
