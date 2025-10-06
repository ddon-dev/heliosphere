extends GPUParticles2D

func _ready() -> void:
	one_shot = true
	restart()
	await finished
	queue_free()
