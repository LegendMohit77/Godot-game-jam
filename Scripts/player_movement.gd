extends CharacterBody2D

@export var speed: float = 350.0
@export var jump_force: float = -900.0
@export var gravity: float = 3000.0
@export var is_gravity_inverted: bool = false  # Set this to true in Level 3

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D	
@export var coyote_time: float = 0.1 
@export var jump_buffer_time: float = 0.2 

var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0
var direction: float = 0.0

func _ready():
	if is_gravity_inverted:
		gravity *= -1  # Reverse gravity
		jump_force *= -1  # Reverse jump direction
		sprite.flip_v = true  # Flip sprite vertically

func _physics_process(delta):
	# 🔥 Correct ground detection in both gravity modes
	var on_ground = is_on_floor() if not is_gravity_inverted else is_on_ceiling()

	# Apply gravity properly
	if not on_ground:
		velocity.y += gravity * delta
	
	direction = Input.get_axis("left", "right")
	
	if direction != 0:
		velocity.x = direction * speed
		sprite.scale.x = -1 if direction < 0 else 1 
	else:
		velocity.x = 0 
	
	# 🔥 Coyote Time
	if on_ground:
		coyote_timer = coyote_time
	else:
		coyote_timer -= delta
	
	# 🔥 Jump Buffer
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time
	
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta
		if coyote_timer > 0:
			velocity.y = jump_force  # Correct jump force
			coyote_timer = 0
			jump_buffer_timer = 0
	
	# 🔥 Proper Variable Jump (Short Hop Fix)
	if Input.is_action_just_released("jump"):
		# If gravity is normal, cancel jump if still rising
		if not is_gravity_inverted and velocity.y < 0:
			velocity.y *= 0.4  # Reduce jump height
		# If gravity is inverted, cancel jump if still moving up (which is now positive velocity)
		elif is_gravity_inverted and velocity.y > 0:
			velocity.y *= 0.4  # Reduce jump height
	
	# Move character
	move_and_slide()
