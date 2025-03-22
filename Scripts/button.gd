extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var activated: bool = false

@export var gate: NodePath  # Assign the gate node in the Inspector

func _on_body_entered(body: CharacterBody2D) -> void:
	if activated:
		return

	activated = true
	animated_sprite.play("pushed")
	await animated_sprite.animation_finished

	var gate_node = get_node(gate)  # Get the gate node
	if gate_node:
		gate_node.open_gate()  # Tell the gate to open
