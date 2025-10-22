extends Node

const ENEMY_SH_HOMING = preload("uid://cngao3yus1p60")
@onready var shooter_spawn_x_min: float = 81.0
@onready var shooter_spawn_x_max: float
@onready var shooter_spawn_y: float = -71.0

func _ready() -> void:
	var viewport_size = get_viewport().size
	shooter_spawn_x_max = viewport_size.x - 81

func spawn_sh_homing():
	var enemy = ENEMY_SH_HOMING.instantiate()
	enemy.position = Vector2(randf_range(shooter_spawn_x_min,shooter_spawn_x_max),shooter_spawn_y)
	add_child(enemy)
