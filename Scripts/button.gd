extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var activated: bool = false
func _on_body_entered(body: CharacterBody2D) -> void:
	if activated:
		return
		
	activated = true
	animated_sprite.play("pushed")
	await animated_sprite.animation_finished
	
