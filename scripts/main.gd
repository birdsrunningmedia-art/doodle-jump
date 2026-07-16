extends Node

@export var platform_scene: PackedScene
@export var broken_platform_scene: PackedScene
@export var platform_with_spring_scene: PackedScene

var platform_container: Array[Node] = []
var screen_size

var y = 18
var jump_value = 17


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport().size
	spawn_platform()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_platform():
	for a in range(49):
		if a % jump_value == 0:
			var platform = platform_scene.instantiate()
			# Later change the multiplier from 3 to 4 in the y co-ordinate of the platform position.
			platform.global_position = Vector2(randi_range(36, 324), (screen_size.y - 18) - 3 * a * 9)
			platform_container.append(platform)
		else:
			var randomizer = randi_range(0, 3)
			
			if randomizer == 0:
				# That is no platform is created.
				continue
			elif randomizer == 1:
				var platform = platform_scene.instantiate()
				# Later change the multiplier from 3 to 4 in the y co-ordinate of the platform position.
				platform.global_position = Vector2(randi_range(36, 324), (screen_size.y - 18) - 4 * a * 9)
				platform_container.append(platform)
			elif randomizer == 2:
				var broken_platform = broken_platform_scene.instantiate()
				# Later change the multiplier from 3 to 4 in the y co-ordinate of the platform position.
				broken_platform.global_position = Vector2(randi_range(36, 324), (screen_size.y - 18) - 4 * a * 9)
				platform_container.append(broken_platform)
			elif randomizer == 3:
				var platform_with_spring = platform_with_spring_scene.instantiate()
				# Later change the multiplier from 3 to 4 in the y co-ordinate of the platform position.
				platform_with_spring.global_position = Vector2(randi_range(36, 324), (screen_size.y - 18) - 4 * a * 9)
				platform_container.append(platform_with_spring)
			
	for platform in platform_container:
		add_child(platform)
	


