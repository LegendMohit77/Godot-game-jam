extends Area2D

@export var next_level: String = "res://Scenes/Level2.tscn"
@export var requires_button: bool = false  # If true, the gate only opens when the button is pressed
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var is_open: bool = false  # Tracks if the gate is open
var player_inside: bool = false  # Tracks if the player is inside

func open_gate():
	if is_open:
		return  # Prevent reopening

	is_open = true
	animated_sprite.play("Open")
	await animated_sprite.animation_finished  # Wait for animation to finish

	# If the player is already inside, transition now
	if player_inside:
		transition_to_next_level()

func _on_body_entered(body: CharacterBody2D) -> void:
	
	if body.is_in_group("player"):
		
		player_inside = true  # Mark player as inside

		if is_open:  # If the gate is already open, transition directly
			AudioManager.win.play()
			transition_to_next_level()
		elif not requires_button:  # If no button is required, open immediately
			open_gate()
			
			await animated_sprite.animation_finished  
			AudioManager.win.play()
			transition_to_next_level()

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside=false


func transition_to_next_level():
	var tree = get_tree()  
	if tree:  # Ensure get_tree() is valid before pausing
		tree.paused = true
		await tree.create_timer(0.5).timeout
		tree.paused = false
		tree.change_scene_to_file(next_level)
