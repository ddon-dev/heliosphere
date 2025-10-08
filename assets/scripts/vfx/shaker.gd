extends Node2D

@export var camera: Camera2D
var shake_time_left: float = 2.0
var ult_shake_left: float = 1.0
@export var intensity: float = 5.0
var current_intensity: float
var ult_intensity: float
var intensity_tween: Tween
var ultShake_tween: Tween
var playerDeath_tween: Tween
@export var max_intensity: float = 13
@export var enemyHitShake: float = 1
@export var enemyExplosionShake: float = 5
@export var playerSmallBoomShake: float = 3
@export var playerExplodedShake: float = 6
@export var ultFiring: float = 16

func _ready() -> void:
	GameManager.enemyExploded.connect(func():
		self.shake(1,enemyExplosionShake)
		)
	GameManager.enemyHit.connect(func():
		self.shake(0.6,enemyHitShake)
		)
	GameManager.playerExploding.connect(func():
		self.shake(0.5,playerSmallBoomShake)
		)
	GameManager.playerExploded.connect(func():
		self.shake(2,playerExplodedShake)
		)
	GameManager.ultFiring.connect(func():
		self.ult_shake(7,ultFiring)
		)
func shake(duration: float, shake_intensity: float = intensity):
	shake_time_left = duration
	current_intensity += shake_intensity
	current_intensity = min(current_intensity, max_intensity)
	if intensity_tween && intensity_tween.is_valid():
		intensity_tween.kill()
	intensity_tween = create_tween()
	intensity_tween.tween_property(self, 
	"current_intensity",
	0.0,
	shake_time_left)

func ult_shake(duration: float, shake_intensity: float = intensity):
	ult_shake_left = duration
	ult_intensity = shake_intensity
	ult_intensity = min(ult_intensity, ult_intensity)
	if ultShake_tween && ultShake_tween.is_valid():
		ultShake_tween.kill()
	ultShake_tween = create_tween()
	ultShake_tween.tween_property(self, 
	"ult_intensity",
	0.0,
	ult_shake_left)

func _process(delta: float) -> void:
	shake_time_left = move_toward(
		shake_time_left,
		0.0,
		delta
	)
	if shake_time_left > 0:
		camera.offset = Vector2(
			randf_range(-current_intensity, current_intensity),
			randf_range(-current_intensity, current_intensity))
			
	ult_shake_left = move_toward(
		ult_shake_left,
		0.0,
		delta
	)
	if ult_shake_left > 0:
		camera.offset = Vector2(
			randf_range(-ult_intensity, ult_intensity),
			randf_range(-ult_intensity, ult_intensity))
