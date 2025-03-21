extends CharacterBody2D

@export var speed: float = 300.0
@export var jump_force: float = -600.0
@export var gravity: float = 900.0
@export var acceleration: float = 0.2
@export var friction: float = 0.1

@export var coyote_time: float = 0.1  # Time player can still jump after leaving a platform
@export var jump_buffer_time: float = 0.5  # Time a jump input is buffered before landing

var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0
var direction: float = 0.0

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		if velocity.y>0:
			velocity.y+=gravity*2*delta
		else:
			velocity.y += gravity * delta

	# Handle input
	direction = Input.get_axis("left", "right")

	# Apply acceleration and friction
	if direction != 0:
		velocity.x = lerp(velocity.x, direction * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)

	# Coyote time logic
	if is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer -= delta

	# Jump buffering
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time

	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta
		if coyote_timer > 0:
			velocity.y = jump_force
			coyote_timer = 0
			jump_buffer_timer = 0

	# Variable jump height (short hop)
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= 0.4

	# Move character
	move_and_slide()
