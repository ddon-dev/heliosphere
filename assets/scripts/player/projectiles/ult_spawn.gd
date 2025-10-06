extends Node2D

@export var spawn_point: Marker2D
@onready var main: player = $"../.."

@onready var ultBeam: PackedScene = preload("uid://cjktfoqagv4e6")

func fire():
	GameManager.ultFiring.emit()
	var ult = ultBeam.instantiate()
	get_parent().add_child(ult)
	ult.position = spawn_point.position
