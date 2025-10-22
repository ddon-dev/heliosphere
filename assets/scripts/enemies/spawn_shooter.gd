extends Node

const ENEMY_SHOOTER = preload("uid://cv51cjqwonc44")
@onready var shooter_spawn_x_min: float = 68
@onready var shooter_spawn_x_max: float
@onready var shooter_spawn_y: float = -65

func _ready() -> void:
	var viewport_size = get_viewport().size
	shooter_spawn_x_max = viewport_size.x - 68

func spawn_shooter():
	var enemy = ENEMY_SHOOTER.instantiate()
	enemy.position = Vector2(randf_range(shooter_spawn_x_min,shooter_spawn_x_max),shooter_spawn_y)
	add_child(enemy)
