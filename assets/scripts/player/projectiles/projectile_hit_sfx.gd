extends AudioStreamPlayer

func hit():
	play()
	await finished
	queue_free()
