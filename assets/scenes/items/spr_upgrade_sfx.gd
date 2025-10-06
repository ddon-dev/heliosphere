extends AudioStreamPlayer

func item_get():
	play()
	await finished
	queue_free()
