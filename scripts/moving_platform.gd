extends AnimatableBody2D

signal leaves_screen

var screen_size
var velocity := Vector2(180, 0) # Moving right

func _ready() -> void:
	screen_size = get_viewport().size

func _physics_process(delta: float) -> void:
	position += velocity * delta

	# Hit left edge
	if global_position.x - 31 < 0:
		# velocity.x *= -1
		velocity = Vector2(180, 0)

	# Hit right edge
	elif global_position.x + 31 > screen_size.x:
		# velocity.x *= -1
		velocity = Vector2(-180, 0)

func play_bounce():
	$AudioStreamPlayer2D.play()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	leaves_screen.emit()
	queue_free()
