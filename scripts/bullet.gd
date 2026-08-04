extends Area2D

@export var speed = 2400


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += Vector2.RIGHT.rotated(rotation) * speed * delta

# func _on_body_entered(body: Node2D) -> void:
# 	if body.is_in_group("asteroids"):
# 		var contact_pos: Vector2 = global_position
# 		var body_group: String = "asteroids"
# 		emit_signal("exploded_at", contact_pos, body_group)
# 		body.explode()
# 		queue_free()
# 	elif body.is_in_group("medium_asteroids"):
# 		if body.is_in_group("medium_asteroids"):
# 			var contact_pos: Vector2 = global_position
# 			var body_group: String = "medium_asteroids"
# 			emit_signal("exploded_at", contact_pos, body_group)
# 			body.explode()
# 			queue_free()
# 	elif body.is_in_group("mini_asteroids"):
# 		var contact_pos: Vector2 = global_position
# 		emit_signal("exploded_at", contact_pos, "mini_asteroids")
# 		body.explode()
# 		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		area.die()
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
