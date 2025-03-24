extends CharacterBody2D
var was_in_air: bool = false
@export var speed: float = 350.0
@export var jump_force: float = -900.0
@export var gravity: float = 3000.0
@export var is_gravity_inverted: bool = false 
@export var push_force: float = 50
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D	
@export var coyote_time: float = 0.1 
@export var jump_buffer_time: float = 0.2 
@export var reversed_controls: bool = false  


var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0
var direction: float = 0.0

func _ready():
	if is_gravity_inverted:
		gravity *= -1 
		jump_force *= -1 
		sprite.flip_v = true 

func _physics_process(delta):
	
	var on_ground = is_on_floor() if not is_gravity_inverted else is_on_ceiling()
	
	
	if not on_ground:
		velocity.y += gravity * delta
	
	direction = Input.get_axis("left", "right")
	if reversed_controls:
		direction *= -1
	if direction != 0:
		velocity.x = direction * speed
		sprite.scale.x = -1 if direction < 0 else 1 
	else:
		velocity.x = 0 
	
	
	if on_ground:
		coyote_timer = coyote_time
	else:
		coyote_timer -= delta
	if reversed_controls:
		if Input.is_action_just_released("jump"):  # Normal jump when reversed
			AudioManager.jump.play()
			velocity.y = jump_force*2.5
	else:
		if Input.is_action_just_pressed("jump"):
			AudioManager.jump.play()
		
			jump_buffer_timer = jump_buffer_time
	
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta
		if coyote_timer > 0:
			velocity.y = jump_force 
			coyote_timer = 0
			jump_buffer_timer = 0
	
	
	if Input.is_action_just_released("jump"):
		if not is_gravity_inverted and velocity.y < 0:
			velocity.y *= 0.4 
		
		elif is_gravity_inverted and velocity.y > 0:
			velocity.y *= 0.4  
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var obj = collision.get_collider()
		
		if obj is RigidBody2D:
			obj.apply_impulse(Vector2(direction * push_force, 0))
	
	if was_in_air and on_ground:#land sound
		AudioManager.land.play() 
	
	was_in_air=not on_ground
	
	move_and_slide()
