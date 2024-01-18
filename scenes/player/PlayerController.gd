extends CharacterBody3D

const WALKING_SPEED = 5
const RUNNING_SPEED = 10
var SPEED;
const JUMP_VELOCITY = 15
const DOUBLEJUMP_VELOCITY = 10

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#Initialize values for double jump mechanic
var jumps_left: int
var jumps_amount = 1



func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Handle double jump
	if is_on_floor():
		jumps_left = jumps_amount
	if not is_on_floor():
		if jumps_left > 0:
			if Input.is_action_just_pressed("jump"):
				jumps_left -= 1
				velocity.y = DOUBLEJUMP_VELOCITY
				
	# Handle speed
	if Input.is_action_pressed("run"):
		SPEED = RUNNING_SPEED
	else:
		SPEED = WALKING_SPEED

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	# Flip sprite based on direction
	if velocity.x < 0:
		$PlayerSprite.flip_h = true
	if velocity.x > 0:
		$PlayerSprite.flip_h = false
	
	# Idle animation
	if velocity.x == 0 and velocity.z == 0 and is_on_floor():
		$PlayerSprite.play("idle")
		
	# Walking animation
	elif (velocity.x != 0 or velocity.z != 0) and not Input.is_action_pressed("run") and is_on_floor():
		$PlayerSprite.play("walk")
		
	# Running animation
	elif (velocity.x != 0 or velocity.z != 0) and Input.is_action_pressed("run") and is_on_floor():
		$PlayerSprite.play("run")
		
	# Jumping animation
	if velocity.y > 0 and not is_on_floor():
		$PlayerSprite.play("ascend")	
		if $PlayerSprite.animation_finished:
			$PlayerSprite.stop()
	elif velocity.y < 0 and not is_on_floor():
		$PlayerSprite.play("descend")
		if $PlayerSprite.animation_finished:
			$PlayerSprite.stop()

