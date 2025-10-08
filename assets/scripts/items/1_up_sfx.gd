extends AudioStreamPlayer

func life_get():
	play()
	await finished
	queue_free()
