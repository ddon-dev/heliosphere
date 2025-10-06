extends Node2D

@export var spawn_point: Marker2D
@onready var main: player = $".."

# Projectile Types
var projectileType: PackedScene
var defaultShot: PackedScene = preload("uid://di1otnc825s1r")
var pierceShot: PackedScene = preload("uid://2lk686b1mi6t")
var spreadShot: PackedScene = preload("uid://k5uhnxp5joq8")

# Projectile properties (Amount, Arc.)
@export var bullet_count: int = 1
@export_range(0,360, 1) var spread_arc: float = 45

func _process(_delta: float) -> void:
	if GameManager.hasPierce:
		projectileType = pierceShot
	elif GameManager.hasSpread:
		projectileType = spreadShot
	else:
		projectileType = defaultShot

func fire():
	if projectileType == spreadShot:
		bullet_count = 3
		for i in bullet_count:
			var projectile = projectileType.instantiate()
			projectile.position = spawn_point.global_position
			var arc_rad = deg_to_rad(spread_arc)
			var increment = arc_rad / (bullet_count - 1)
			projectile.global_rotation = (
				global_rotation +
				increment * i -
				arc_rad / 2
			)
			get_tree().root.call_deferred("add_child", projectile)
	else:
		var projectile = projectileType.instantiate()
		bullet_count = 1
		projectile.position = spawn_point.global_position
		get_tree().root.call_deferred("add_child", projectile)
