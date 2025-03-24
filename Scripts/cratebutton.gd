extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var activated: bool = false

@export var gate: NodePath  # Assign the gate node in the Inspector

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("crate"):  # Only react if the crate enters
		
		if activated:
			return

		activated = true
		AudioManager.button.play()
		animated_sprite.play("pushed")
		await animated_sprite.animation_finished

		var gate_node = get_node(gate)  # Get the gate node
		if gate_node:
			gate_node.open_gate()  # Tell the gate to open
