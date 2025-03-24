extends Area2D

@export var next_level: String = "res://Scenes/Level2.tscn"
@export var requires_button: bool = false  # If true, the gate only opens when the button is pressed
@export var requires_both_buttons: bool = false  # Set to true if both buttons are required

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var hide_gate_sprite: bool = false

var is_open: bool = false  
var player_inside: bool = false  

var player_button_pressed: bool = false
var crate_button_pressed: bool = false

func _ready():
	if hide_gate_sprite:
		animated_sprite.visible = false

func set_player_button(state: bool):
	player_button_pressed = state
	check_gate_open()

func set_crate_button(state: bool):
	crate_button_pressed = state
	check_gate_open()

func check_gate_open():
	# If the level requires both buttons, wait for both
	if requires_both_buttons:
		if player_button_pressed and crate_button_pressed:
			open_gate()
	else:
		# If only one button is needed, open if either is pressed
		if player_button_pressed or crate_button_pressed:
			open_gate()

func open_gate():
	if is_open:
		return  

	is_open = true
	animated_sprite.play("Open")
	await animated_sprite.animation_finished  

	if player_inside:
		transition_to_next_level()

func _on_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("player"):
		player_inside = true  

		if is_open:  
			AudioManager.win.play()
			transition_to_next_level()
		elif not requires_button:  
			open_gate()
			await animated_sprite.animation_finished  
			AudioManager.win.play()
			transition_to_next_level()

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside = false

func transition_to_next_level():
	var tree = get_tree()  
	if tree:  
		tree.paused = true
		await tree.create_timer(0.5).timeout
		tree.paused = false
		tree.change_scene_to_file(next_level)
