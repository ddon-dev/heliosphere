extends Node

const MINIBOSS = preload("uid://dd1jpc1w3ffg")
	
func spawn_miniboss():
	var miniboss = MINIBOSS.instantiate()
	var viewport_size = get_viewport().size
	miniboss.position = Vector2(viewport_size.x /2, -184)
	add_child(miniboss)
