extends CharacterBody2D

var is_hurt = false
var max_health = 25  # Boss total health
var current_health = max_health
var damage_amount = 1
var player = null
var is_following = false
var is_attacking = false
var attack_range = false
var speed: float = 100.0  # Speed of the enemy
var gravity: float = 800.0  # Gravity to keep enemy on the ground
var is_dead = false  # Variable to track death state
var has_attacked = false  # To ensure damage is applied only once per attack

@export var follow_limit_left = -400  # Original left patrol limit
@export var follow_limit_right = 400  # Original right patrol limit
var original_follow_limit_left = -400  # Original left patrol limit
var original_follow_limit_right = 400  # Original right patrol limit
var increased_follow_limit_left = -800  # Increased left patrol limit
var increased_follow_limit_right = 800  # Increased right patrol limit

@onready var hitbox = $hitbox  # Reference to the hitbox
@onready var hurtbox = $hurtbox  # Reference to the hurtbox
@onready var melee = $melee_area
@onready var slam = $slam_area
@onready var collision = $CollisionShape2D
@onready var anim_sprite = $AnimatedSprite2D

@onready var damage_timer = $Timer
const GAME_SCENE_PATH: String = "res://scenes/End.tscn"  # Path to the game over/end scene

func _ready():
	player = get_parent().get_node("PLAYER")
	damage_timer.wait_time = 1.5  # Set the damage interval to 1.5 seconds
	damage_timer.connect("timeout", Callable(self, "_apply_continuous_damage"))  # Connect the timer's timeout to a function

func _process(delta):
	if is_dead:
		return  # Do nothing if the enemy is dead

	# Apply gravity
	velocity.y += gravity * delta  # Gravity is applied every frame

	if player:
		var direction = player.global_position.x - global_position.x

		# Check if the player is within the increased follow limits
		if direction > follow_limit_left and direction < follow_limit_right:
			if not is_following:
				is_following = true
				# Set to increased follow limits
				follow_limit_left = increased_follow_limit_left
				follow_limit_right = increased_follow_limit_right

			# Move towards the player only if not attacking
			if not is_attacking and not is_hurt:
				if direction < 0:
					velocity.x = -speed  # Move left
					get_node("melee_area").set_scale(Vector2(1, 1))
					anim_sprite.flip_h = false  # Face left
				elif direction > 0:
					velocity.x = speed  # Move right
					get_node("melee_area").set_scale(Vector2(-1, 1))
					anim_sprite.flip_h = true  # Face right
				# Start the run animation when moving
				if anim_sprite.animation != "run":
					anim_sprite.play("run")
			
			else:
				velocity.x = 0
			
			if anim_sprite.animation == "attack":
				# Check if the current frame is within the specified range
				if anim_sprite.frame >= 9 and anim_sprite.frame <= 13 and attack_range and not has_attacked:
					AudioManager.boss_attack_sfx.play()
					has_attacked = true
					
					player.take_damage(damage_amount)  # Deal damage to the player
		else:
			# Reset to original follow limits if the player is out of range
			if is_following:
				is_following = false
				follow_limit_left = original_follow_limit_left
				follow_limit_right = original_follow_limit_right

			velocity.x = 0  # Stop moving if player is out of bounds

			# Play idle animation when not moving
			if anim_sprite.animation != "idle":
				anim_sprite.play("idle")

	# Move the enemy
	move_and_slide()

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		player.take_damage(damage_amount)

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Sword"):
		AudioManager.enemy_hurt_sfx.play()
		take_damage()

func take_damage():
	if is_dead:  # Prevent further actions if dead
		return
	
	if current_health > 0:
		if not is_attacking:  # Only play hurt animation if not attacking
			is_hurt = true
			anim_sprite.play("hurt")
		current_health -= 1
		print("damaged. health is:", current_health)
		if current_health <= 0:
			is_dead = true
			die()

func die():
	if is_dead:
		AudioManager.boss_dies_sfx.play()
		anim_sprite.play("die")  # Play the death animation
		hitbox.queue_free()
		hurtbox.queue_free()
		melee.queue_free()
		slam.queue_free()
		collision.queue_free()

# When player enters the melee attack area, start the damage timer
func _on_melee_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		attack_range = true
		is_attacking = true
		has_attacked = false
		attack()
		damage_timer.start()  # Start applying continuous damage

# When player exits the melee attack area, stop the damage timer
func _on_melee_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("Player"):
		attack_range = false
		damage_timer.stop()  # Stop applying continuous damage

func attack():
	if is_attacking:
		anim_sprite.play("attack")
		

# Apply damage to the player every 1.5 seconds while inside the area
func _apply_continuous_damage():
	if attack_range and player:
		player.take_damage(damage_amount)
		print("Player damaged for staying in the attack range.")

func _on_animated_sprite_2d_animation_finished() -> void:
	if anim_sprite.animation == "attack":
		is_attacking = false
		has_attacked = false
	if anim_sprite.animation == "hurt":
		is_hurt = false
	if anim_sprite.animation == "die" and is_dead:
		get_tree().change_scene_to_file(GAME_SCENE_PATH)  # Change scene after the death animation finishes
