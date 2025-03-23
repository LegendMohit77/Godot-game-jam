extends Area2D

@onready var anim= $AnimatedSprite2D
@export var enterable :bool = false
@export var next_level: String = "res://Scenes/Level5.tscn"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim.play("Open")
	await anim.animation_finished

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if enterable:
			var tree = get_tree()  
			if tree:  # Ensure get_tree() is valid before pausing
				tree.paused = true
				await tree.create_timer(0.5).timeout
				tree.paused = false
				tree.change_scene_to_file(next_level)
