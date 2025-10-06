extends GPUParticles2D

@onready var time_til_delete: Timer = $time_til_delete

func _ready() -> void:
	emitting = true

func _on_time_til_delete_timeout() -> void:
	queue_free()

func _on_tree_exited() -> void:
	pass
