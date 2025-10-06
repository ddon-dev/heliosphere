extends Node2D

@onready var hit_sfx: AudioStreamPlayer2D = $AudioStreamPlayer2D
@export var damage_dealt: int = 5
@export var lifetime: Timer
@onready var area_2d: Area2D = $Sprite2D/Area2D

func _on_lifetime_timeout() -> void:
	GameManager.canShoot = true
	GameManager.ult_finished()
	queue_free()

func _physics_process(_delta: float) -> void:
	if area_2d.has_overlapping_areas():
		hit_sfx.play()
