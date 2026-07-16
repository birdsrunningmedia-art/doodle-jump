extends CharacterBody2D

@export var move_speed := 250.0
@export var gravity := 900.0
@export var jump_velocity := -600.0

func _physics_process(delta):
	# Horizontal movement
	var direction := Input.get_axis("move_left", "move_right")
	velocity.x = direction * move_speed

	# Gravity
	velocity.y += gravity * delta

	# Move the player
	move_and_slide()

	# Bounce only when landing while falling
	if is_on_floor():
		velocity.y = jump_velocity
