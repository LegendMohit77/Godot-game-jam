extends Camera2D

@export var shake_intensity: float = 10.0  # Maximum shake strength
@export var shake_duration: float = 0.2  # Duration of shake

var shake_time: float = 0.0

func _process(delta):
	if shake_time > 0:
		shake_time -= delta
		offset = Vector2(randf_range(-shake_intensity, shake_intensity), randf_range(-shake_intensity, shake_intensity))
	else:
		offset = Vector2.ZERO  # Reset camera position after shaking

func start_shake(intensity: float = 10.0, duration: float = 0.2):
	shake_intensity = intensity
	shake_time = duration
