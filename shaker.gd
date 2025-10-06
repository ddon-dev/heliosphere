extends Node2D

@export var camera: Camera2D
var shake_time_left: float = 2.0
@export var intensity: float = 5.0
var current_intensity: float
var intensity_tween: Tween

#func _ready() -> void:
	#GameManager.enemyExploded.connect()
	#GameManager.enemyHit.connect()
	#GameManager.playerExploding.connect()
	#GameManager.playerExploded.connect()

func shake(duration: float, shake_intensity: float = intensity):
	shake_time_left = duration
	current_intensity = shake_intensity
	if intensity_tween && intensity_tween.is_valid():
		intensity_tween.kill()
	intensity_tween = create_tween()
	intensity_tween.tween_property(self, 
	"current_intensity",
	0.0,
	duration)

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
