extends Area2D

signal reached

var screen_size


@export var player: CharacterBody2D

@export var allowance = 100 # in pixel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.velocity.y < 0 and player.global_position.y < global_position.y + screen_size.y / 2 + allowance:
		global_position.y = player.global_position.y + screen_size.y / 2 + allowance
	# No need to follow player when falling.

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.death_sequence()
		reached.emit()
