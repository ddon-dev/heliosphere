extends Node

const ENEMY_CHASER = preload("uid://sm7cffe8fgqo")
@onready var chaser_spawn_x_min: float = 35
@onready var chaser_spawn_x_max: float
@onready var chaser_spawn_y: float = -18

func _ready() -> void:
	var viewport_size = get_viewport().size
	chaser_spawn_x_max = viewport_size.x - 35

func spawn_chaser():
	var enemy = ENEMY_CHASER.instantiate()
	enemy.position = Vector2(randf_range(chaser_spawn_x_min,chaser_spawn_x_max),chaser_spawn_y)
	add_child(enemy)
