extends CharacterBody2D

@export var speed: float = 350.0
@export var jump_force: float = -900.0
@export var gravity: float = 3000.0
@export var is_gravity_inverted: bool = false 
@export var push_force: float = 50
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D	
@export var coyote_time: float = 0.1 
@export var jump_buffer_time: float = 0.2 

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
	
	if direction != 0:
		velocity.x = direction * speed
		sprite.scale.x = -1 if direction < 0 else 1 
	else:
		velocity.x = 0 
	
	
	if on_ground:
		coyote_timer = coyote_time
	else:
		coyote_timer -= delta
	
	
	if Input.is_action_just_pressed("jump"):
		
		jump_buffer_timer = jump_buffer_time
	
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta
		if coyote_timer > 0:
			velocity.y = jump_force 
			coyote_timer = 0
			jump_buffer_timer = 0
	
	
	if Input.is_action_just_released("jump"):
		AudioManager.jump.play()
		
		if not is_gravity_inverted and velocity.y < 0:
			velocity.y *= 0.4 
		
		elif is_gravity_inverted and velocity.y > 0:
			velocity.y *= 0.4  
			
			#push
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var obj = collision.get_collider()
		
		if obj is RigidBody2D:
			obj.apply_impulse(Vector2(direction * push_force, 0))
	
	move_and_slide()
