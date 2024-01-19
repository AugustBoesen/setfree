extends CharacterBody3D

@onready var anim = $PlayerSprite

@onready var ripplesound = $RippleSound
@onready var walksound = $WalkSound
var jumpripple = load("res://scenes/player/doublejump_ripple.tscn")

var crystals = 0

var speed
var walking_speed = 6
var running_speed = 11

var gravity := -25

var h_accel := 50
var v_accel := 35

var jump_velocity := 15
var doublejump_velocity := 10
@export var max_jumps = 2
var jump_amount = 2

var movement_vector := Vector3.ZERO


	
func handle_animations():
# Flip sprite
	if velocity.x < -0.1:
		anim.flip_h = true
	if velocity.x > 0.1:
		anim.flip_h = false
		
# Idle
	if is_on_floor() and velocity.x == 0 and velocity.z == 0:
		anim.play("idle")
		
# Walking and running
	if is_on_floor() and velocity.x != 0 or velocity.z != 0:
		if Input.is_action_pressed("run"):
			anim.play("run")
			# Running sound
			if $WalkSound/WalkTimer.time_left <= 0 and is_on_floor():
				walksound.pitch_scale = randf_range(0.8, 1.2)
				walksound.play()
				$WalkSound/WalkTimer.start(0.2)
		else:
			anim.play("walk")
			# Walking sound
			if $WalkSound/WalkTimer.time_left <= 0 and is_on_floor():
				walksound.pitch_scale = randf_range(0.8, 1.2)
				walksound.play()
				$WalkSound/WalkTimer.start(0.3)

#Ascending and descending
	if not is_on_floor() and velocity.y != 0:
		if velocity.y > 0:
			anim.play("ascend")
		elif velocity.y < -10:
			anim.play("descend")
		else:
			anim.play("midair")
		
func player_movement(delta):
#Toggle running
	if Input.is_action_pressed("run"):
		speed = running_speed
	else:
		speed = walking_speed

# Horizontal movement
	var horizontal_input := Vector3.ZERO
	horizontal_input.x = Input.get_axis("move_left", "move_right")
	horizontal_input.z = Input.get_axis("move_up", "move_down")
	horizontal_input = horizontal_input.limit_length(1)
	horizontal_input *= speed
	horizontal_input.y = movement_vector.y
	movement_vector = movement_vector.move_toward(horizontal_input, h_accel * delta)
	
# Gravity
	movement_vector.y = move_toward(movement_vector.y, gravity, v_accel * delta)

# Optimization
	set_velocity(movement_vector)
	set_up_direction(Vector3.UP)

func jumping():
# Basic jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
# Double jump
	if is_on_floor():
		jump_amount = max_jumps
	if jump_amount > 0:
		if Input.is_action_just_pressed("jump") and not is_on_floor() and velocity.y < 5:
			velocity.y = doublejump_velocity
			jump_amount -= 1
			# Ripple animation spawning mechanic
			var ripple = jumpripple.instantiate()
			add_child(ripple)
			ripple.emitting = true
			
			# Ripple sound
			ripplesound.pitch_scale = randf_range(0.95, 1.05)
			ripplesound.play()

func hovering():
	#If space is pressed, the mid-air animation loops, creating a 'flying' effect
	if not is_on_floor() and Input.is_action_pressed("jump") and velocity.y < -8:
		velocity.y = -8
		
func activate():
	if Input.is_action_just_pressed("activate"):
		print("katsotaas")
		var objectsInRange = $ActivateArea.get_overlapping_areas()
		if objectsInRange == []:
			print("ei objekteja")
		if objectsInRange != []:
			var objectInRange = objectsInRange[0]
			if objectInRange is CrystalActivate:
				print("löyty")
				objectInRange.get_parent_node_3d().queue_free()
				crystals += 1


func _physics_process(delta):
	player_movement(delta)
	move_and_slide()
	handle_animations()
	jumping()
	hovering()
	activate()
	movement_vector = velocity
