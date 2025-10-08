extends Node

const ENEMY_CHARGER = preload("uid://nuo8r1sgp4we")
@onready var charger_spawn_x_min: float = 35
@onready var charger_spawn_x_max: float
@onready var charger_spawn_y: float = -18

func _ready() -> void:
	var viewport_size = get_viewport().size
	charger_spawn_x_max = viewport_size.x - 35
	
func spawn_charger():
	var enemy = ENEMY_CHARGER.instantiate()
	enemy.position = Vector2(randf_range(charger_spawn_x_min,charger_spawn_x_max),charger_spawn_y)
	add_child(enemy)
