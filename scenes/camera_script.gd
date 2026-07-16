extends Camera2D

var screen_size


@export var player: CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.velocity.y < 0 and player.global_position.y < global_position.y:
		global_position.y = player.global_position.y

	if player.global_position.y > global_position.y + screen_size.y / 2:
		# var z_position = global_position.lerp(player.global_position, 5 * delta)
		global_position.y = player.global_position.y + screen_size.y
		# global_position.y = z_position.y

# func _process(delta):
# 	var should_follow := false

# 	if player.velocity.y < 0 and player.global_position.y < global_position.y:
# 		should_follow = true

# 	if player.global_position.y > global_position.y + screen_size.y / 2:
# 		should_follow = true

# 	if should_follow:
# 		global_position.y = lerp(
# 			global_position.y,
# 			player.global_position.y,
# 			5.0 * delta
# 		)

# How do I now create a scene for this, would the camera 2d be in the main or how?

# if player.velocity.y < 0 and player.global_position.y < global_position.y:
#     global_position.y = player.global_position.y
# if player.global_position.y > global_position.y + screen_height / 2:
#     global_position.y = player.global_position.y

# global_position = global_position.lerp(player.global_position, 5 * delta)


# func _process(delta):
# 	var should_follow := false

# 	if player.velocity.y < 0 and player.global_position.y < global_position.y:
# 		should_follow = true

# 	if player.global_position.y > global_position.y + screen_size.y / 2:
# 		should_follow = true

# 	if should_follow:
# 		global_position.y = lerp(
# 			global_position.y,
# 			player.global_position.y,
# 			5.0 * delta
# 		)