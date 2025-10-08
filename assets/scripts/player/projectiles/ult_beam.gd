extends Node2D

@onready var hit_sfx: AudioStreamPlayer2D = $AudioStreamPlayer2D
@export var damage_dealt: int = 5
@export var lifetime: Timer
@export var time_between_hits: Timer
@onready var area_2d: Area2D = $Sprite2D/Area2D

func _ready() -> void:
	time_between_hits.start()

func _on_lifetime_timeout() -> void:
	GameManager.canShoot = true
	GameManager.playerHurtable = true
	GameManager.ult_finished()
	queue_free()

func _physics_process(_delta: float) -> void:
	if area_2d.has_overlapping_areas():
		var enemies = area_2d.get_overlapping_areas()
		for area in enemies:
			await time_between_hits.timeout
			if is_instance_valid(area):
				if area.has_method("hurt"):
					area.hurt("hurt")
					hit_sfx.play()
					hit_sfx.reparent(get_tree().get_root())
				
#func _on_area_2d_area_entered(area: Area2D) -> void:
	#if area.has_method("hurt"):
			#area.hurt("hurt")
			#hit_sfx.play()
			#hit_sfx.reparent(get_tree().get_root())
