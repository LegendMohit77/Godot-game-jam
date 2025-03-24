extends RigidBody2D

func _ready():
	gravity_scale = 1.0  # Falls normally
	freeze_mode = RigidBody2D.FREEZE_MODE_STATIC  # Allows movement but prevents rotation

	# Lock rotation using PhysicsServer2D
	PhysicsServer2D.body_set_state(self.get_rid(), PhysicsServer2D.BODY_STATE_ANGULAR_VELOCITY, 0)

	# Apply friction & damping
	PhysicsServer2D.body_set_param(self.get_rid(), PhysicsServer2D.BODY_PARAM_FRICTION, 5.0)  # Increase friction
	PhysicsServer2D.body_set_param(self.get_rid(), PhysicsServer2D.BODY_PARAM_LINEAR_DAMP, 4.0)  # Reduce sliding
