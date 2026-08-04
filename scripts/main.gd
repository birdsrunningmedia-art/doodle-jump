extends Node

@export var platform_scene: PackedScene
@export var broken_platform_scene: PackedScene
@export var platform_with_spring_scene: PackedScene
@export var platform_with_rocket_scene: PackedScene
@export var platform_with_heli_hat_scene: PackedScene
@export var disappearing_platform_scene: PackedScene
@export var moving_platform_scene: PackedScene
@export var enemy_scene: PackedScene
@export var crash_site_scene: PackedScene

var platform_container: Array[Node] = []
var screen_size

var new_y
var false_y
var prev_false_y
var prev_y = 620 # In pixels
var min_vertical
var max_vertical
const INITIAL_POS = Vector2(180, 620) # In pixels
var next_pos: Vector2

var score = 0

const unit = 9

const jump_value = 16

var ghost_platform = false
var threshold_score = 8000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport().size
	spawn_platforms()
	$Player.start($StartPosition.position)
	$Music.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# spawn platform code
func spawn_platforms():
	# Anchor platform.
	var platform = platform_scene.instantiate()
	# Later change the multiplier from 3 to 4 in the y co-ordinate of the platform position.
	platform.global_position = INITIAL_POS
	platform_container.append(platform)

	for i in range(25):
		var randomizer
		if ghost_platform:
			randomizer = 1
		else:
			randomizer = randi_range(0, 1)
		
		if randomizer == 0:
			# Broken Platform
			if ghost_platform:
				new_y = prev_y - randi_range((9 * unit), (18 * unit))
			else:
				new_y = prev_y - randi_range((3 * unit), (18 * unit))
			next_pos = Vector2(randi_range(36, 324), new_y)
			var broken_platform = broken_platform_scene.instantiate()
			# Later change the multiplier from 3 to 4 in the y co-ordinate of the platform position.
			broken_platform.global_position = next_pos
			platform_container.append(broken_platform)
			ghost_platform = false
			
		elif randomizer == 1:
			if ghost_platform:
				new_y = prev_y - randi_range((9 * unit), (18 * unit))
			else:
				new_y = prev_y - randi_range((3 * unit), (18 * unit))
			next_pos = Vector2(randi_range(36, 324), new_y)
			var new_platform = platform_scene.instantiate()
			new_platform.global_position = next_pos
			platform_container.append(new_platform)
			ghost_platform = false
			
		else:
			continue
			
		# Set prev_y
		if new_y:
			prev_y = new_y
	
	for platforms in platform_container:
		add_child(platforms)

func spawn_single_platform():
	var randomizer
	if ghost_platform:
		randomizer = randi_range(1, platform_difficulty_setter(score))
	
	else:
		randomizer = randi_range(0, platform_difficulty_setter(score))
		
		
	if randomizer == 0:
		# Normal Platform
		if ghost_platform:
			new_y = prev_y - randi_range((9 * unit), (18 * unit))
		else:
			new_y = prev_y - randi_range((3 * unit), (18 * unit))
		next_pos = Vector2(randi_range(36, 324), new_y)
		var new_platform = platform_scene.instantiate()
		new_platform.global_position = next_pos
		add_child(new_platform)
		ghost_platform = false
		
	elif randomizer == 1:
		# Platform with spring
		if ghost_platform:
			new_y = prev_y - randi_range((9 * unit), (18 * unit))
		else:
			new_y = prev_y - randi_range((3 * unit), (18 * unit))
		next_pos = Vector2(randi_range(36, 324), new_y)
		var dice = randi_range(0, 2)
		if dice == 2 or dice == 0 or dice == 1:
			var platform_with_spring = platform_with_spring_scene.instantiate()
			# Later change the multiplier from 3 to 4 in the y co-ordinate of the platform position.
			platform_with_spring.global_position = next_pos
			add_child(platform_with_spring)
			ghost_platform = false
		else:
			var new_platform = platform_scene.instantiate()
			new_platform.global_position = next_pos
			add_child(new_platform)
			ghost_platform = false
		
	elif randomizer == 2:
		# Broken Platform
		if ghost_platform:
			new_y = prev_y - randi_range((9 * unit), (18 * unit))
		else:
			new_y = prev_y - randi_range((3 * unit), (18 * unit))
		next_pos = Vector2(randi_range(36, 324), new_y)
		var broken_platform = broken_platform_scene.instantiate()
		# Later change the multiplier from 3 to 4 in the y co-ordinate of the platform position.
		broken_platform.global_position = next_pos
		add_child(broken_platform)
		ghost_platform = false

	# Platform with Heli hat
	elif randomizer == 3:
		if ghost_platform:
			new_y = prev_y - randi_range((9 * unit), (18 * unit))
		else:
			new_y = prev_y - randi_range((3 * unit), (18 * unit))
		next_pos = Vector2(randi_range(36, 324), new_y)
		var dice = randi_range(0, 2)
		if dice == 2:
			var platform_with_heli_hat = platform_with_heli_hat_scene.instantiate()
			# Later change the multiplier from 3 to 4 in the y co-ordinate of the platform position.
			platform_with_heli_hat.global_position = next_pos
			add_child(platform_with_heli_hat)
			ghost_platform = false
		else:
			var wheel = randi_range(0, 5)
			if wheel == 0 or wheel == 3:
				var broken_platform = broken_platform_scene.instantiate()
				# Later change the multiplier from 3 to 4 in the y co-ordinate of the platform position.
				broken_platform.global_position = next_pos
				add_child(broken_platform)
				ghost_platform = false
			else:
				var new_platform = platform_scene.instantiate()
				new_platform.global_position = next_pos
				add_child(new_platform)
				ghost_platform = false


	# Platform with rocket
	elif randomizer == 4:
		if ghost_platform:
			new_y = prev_y - randi_range((9 * unit), (18 * unit))
		else:
			new_y = prev_y - randi_range((3 * unit), (18 * unit))
		next_pos = Vector2(randi_range(36, 324), new_y)
		var dice = randi_range(0, 4)
		if dice == 4 or dice == 2:
			var platform_with_rocket = platform_with_rocket_scene.instantiate()
			# Later change the multiplier from 3 to 4 in the y co-ordinate of the platform position.
			platform_with_rocket.global_position = next_pos
			add_child(platform_with_rocket)
			ghost_platform = false
		else:
			if score > threshold_score:
				var broken_platform = broken_platform_scene.instantiate()
				broken_platform.global_position = next_pos
				add_child(broken_platform)
				ghost_platform = false
			else:
				var new_platform = platform_scene.instantiate()
				new_platform.global_position = next_pos
				add_child(new_platform)
				ghost_platform = false

	# ghost_platform platform here
	# Disappearing platform
	elif randomizer == 5:
		ghost_platform = true
		false_y = prev_y - randi_range((3 * unit), (6 * unit))
		next_pos = Vector2(randi_range(36, 324), false_y)
		var disappearing_platform = disappearing_platform_scene.instantiate()
		# Later change the multiplier from 3 to 4 in the y co-ordinate of the platform position.
		disappearing_platform.global_position = next_pos
		add_child(disappearing_platform)
		platform_container.append(disappearing_platform)
	elif randomizer == 6:
		# Moving Platform
		if ghost_platform:
			new_y = prev_y - randi_range((9 * unit), (18 * unit))
		else:
			new_y = prev_y - randi_range((3 * unit), (18 * unit))
		next_pos = Vector2(randi_range(36, 324), new_y)
		var moving_platform = moving_platform_scene.instantiate()
		# Later change the multiplier from 3 to 4 in the y co-ordinate of the platform position.
		moving_platform.global_position = next_pos
		add_child(moving_platform)
		ghost_platform = false
	elif randomizer == 7:
		var enemy = enemy_scene.instantiate()
		var pos = Vector2(randi_range(50, 310), randi_range(0, 400))
		enemy.global_position = pos
		add_child(enemy)
		return
	else:
		return

	if new_y:
		prev_y = new_y

func _on_player_generate_platform_threshold() -> void:
	score += 10
	# print("Your score: ", score)
	spawn_single_platform()

func platform_difficulty_setter(game_score) -> int:
	if game_score > 1700 and game_score <= 3200:
		return 2
	elif game_score > 3200 and game_score <= 5300:
		return 3
	elif game_score > 5300 and game_score <= 7400:
		return 4
	elif game_score > 7400 and game_score <= 9400:
		return 5
	elif game_score > 9400 and game_score <= 12400:
		return 6
	elif game_score > 12400:
		return 7
	else:
		return 1


func game_over():
	$GameOverSfx.play()
	print("game over")

func new_game():
	pass
