extends Area2D

@onready var explosion_sfx: AudioStreamPlayer2D = $"ExplosionSfx"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.die()

func die():
	explosion_sfx.reparent(get_parent())
	explosion_sfx.play()
	explosion_sfx.finished.connect(queue_free)
	queue_free()