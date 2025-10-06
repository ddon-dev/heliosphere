extends Node2D

@onready var hit_sfx: AudioStreamPlayer = $AudioStreamPlayer2D
const PARTICLES = preload("uid://dlee18ewn2dna")

@export_range(50, 1000, 5) var speed: float = 830
@export var direction: Vector2 = Vector2.UP
@export var damage_dealt: int = 1
var hasHit: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	direction = Vector2.UP.rotated(global_rotation)

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

func hit():
	GameManager.enemyHit.emit()
	GameManager.ultCharge += 3
	var particles = PARTICLES.instantiate()
	get_parent().add_child(particles)
	particles.global_position = global_position
	particles.reparent(get_tree().get_root())
	hit_sfx.hit()
	hit_sfx.reparent(get_tree().get_root())
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if !hasHit:
		if area.has_method("hurt"):
			area.hurt("hurt")
			hasHit = true
			hit()
