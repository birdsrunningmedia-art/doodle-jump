extends CharacterBody2D

signal generate_platform_threshold
signal death_sequence_signal

@onready var heli_sfx: AudioStreamPlayer2D = $"HeliSfx"
@onready var rocket_sfx: AudioStreamPlayer2D = $"RocketSfx"
@onready var shoot_sfx: AudioStreamPlayer2D = $"ShootSfx"


@export var bullet_scene: PackedScene
var screen_size

@export var die_slow_mo = 5
@export var move_speed := 250.0
@export var gravity := 850.0
@export var boost_acceleration := 1200.0 # Control upward speed gain during boost
@export var max_upward_speed := -1200.0 # Cap upward speed to prevent off-screen clipping
var death_sequence_bool = false

const unit = 9
const jump_value = 16
var jump_velocity := - (unit * jump_value + 3 * unit) / 0.3
var spring_jump_velocity = (3 * unit * jump_value + 3 * unit) / 0.3

var keep_velocity := false
var keep_velocity_time := 0.0

@export var step_size := 27.0
var next_trigger_y := 0.0
var prev_big_y_value := 0.0

var spring_touched_bool = false
var disappearing_platform_bool = false

func _ready():
	# next_trigger_y = global_position.y - step_size
	screen_size = get_viewport().size
	gravity = 0
	hide()
	$CollisionShape2D.disabled = true

func _process(_delta):
	if !death_sequence_bool:
		if global_position.y <= next_trigger_y and velocity.y < 0 and global_position.y < prev_big_y_value:
			on_y_step_reached()
			next_trigger_y -= step_size
			prev_big_y_value = global_position.y
	
		if Input.is_action_just_pressed("shoot"):
			shoot()

func _physics_process(delta):
	# 1. Horizontal movement
	var direction := Input.get_axis("move_left", "move_right")
	velocity.x = direction * move_speed

	# 2. Upward Boost vs. Standard Gravity
	if keep_velocity and keep_velocity_time > 0.0:
		keep_velocity_time -= delta
		
		# Smoothly accelerate upward (negative Y)
		velocity.y -= boost_acceleration * delta
		
		# Cap the maximum upward speed
		velocity.y = maxf(velocity.y, max_upward_speed)

		if keep_velocity_time <= 0.0:
			keep_velocity = false
	else:
		# Apply gravity only when NOT boosting
		if death_sequence_bool:
			velocity.y += delta * die_slow_mo
		else:
			velocity.y += gravity * delta

	# 3. MOVE PLAYER AFTER CALCULATING ALL VELOCITY FORCES
	move_and_slide()

	# 4. Handle collision events
	if get_slide_collision_count() > 0:
		var collision = get_slide_collision(0)
		var body = collision.get_collider()

		if body.is_in_group("broken_platforms"):
			body.contact_action()
		elif body.is_in_group("rigid_springs"):
			spring_touched_bool = true
		elif body.is_in_group("disappearing_platforms"):
			disappearing_platform_bool = true
			body.contact_action()
		body.play_bounce()

	# 5. Handle ground bounciness
	if is_on_floor():
		if spring_touched_bool and velocity.y >= 0:
			velocity.y = - spring_jump_velocity
			spring_touched_bool = false
		elif disappearing_platform_bool and velocity.y >= 0:
			disappearing_platform_bool = false
			return
		else:
			velocity.y = jump_velocity

func on_y_step_reached():
	generate_platform_threshold.emit()
	print("nani?")


func maintain_velocity(duration: float):
	keep_velocity = true
	keep_velocity_time = duration
	
	# Instantly cancel downward momentum so the player doesn't fight gravity on frame 1
	if velocity.y > 0:
		velocity.y = 0.0

func heli_touched():
	if velocity.y <= 0:
		return
	else:
		heli_sfx.play()
		maintain_velocity(2.0)

func rocket_touched():
	if velocity.y <= 0:
		return
	else:
		rocket_sfx.play()
		maintain_velocity(5.0)

func shoot():
	$ShootSfx.play()
	var bullet = bullet_scene.instantiate()

	var bullet_spawn_location = $BulletPath/BulletSpawnLocation
	bullet_spawn_location.progress_ratio = 1

	bullet.position = bullet_spawn_location.position

	# Spawn the mob by adding it to the Main scene.
	get_tree().current_scene.add_child(bullet)

	bullet.global_position = bullet_spawn_location.global_position
	bullet.global_rotation = bullet_spawn_location.global_rotation

func death_sequence():
	death_sequence_bool = true
	death_sequence_signal.emit()

func start(pos):
	death_sequence_bool = false
	$CollisionShape2D.disabled = false
	prev_big_y_value = 0.0
	
	show()
	position = pos
	next_trigger_y = global_position.y - step_size
	velocity.y = jump_velocity
	gravity = 850.0
	$CollisionShape2D.disabled = false


func stop():
	velocity.y = 0
	gravity = 0
	hide()
	$CollisionShape2D.disabled = true