extends StaticBody2D


@onready var puff_sound: AudioStreamPlayer2D = $"AudioStreamPlayer2D"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func contact_action():
	puff_sound.reparent(get_parent())
	puff_sound.play()
	puff_sound.finished.connect(puff_sound.queue_free)
	queue_free()


func play_bounce():
	pass