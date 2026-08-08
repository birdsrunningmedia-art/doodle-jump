extends StaticBody2D

@onready var broken_sound: AudioStreamPlayer2D = $"AudioStreamPlayer2D"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func contact_action():
	broken_sound.reparent(get_parent())
	broken_sound.play()
	broken_sound.finished.connect(broken_sound.queue_free)
	queue_free()

func play_bounce():
	pass
