extends Node2D

@onready var hit_sfx: AudioStreamPlayer = $AudioStreamPlayer2D
const PARTICLES = preload("uid://csl1tiivah0ht")

@export_range(50, 1000, 5) var speed: float = 830
@onready var area_2d: Area2D = $Area2D
@export var direction: Vector2 = Vector2.UP
@export var damage_dealt: int = 1
var hasHit: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta
	
func hit():
	GameManager.ultCharge += 3
	var particles = PARTICLES.instantiate()
	get_parent().add_child(particles)
	particles.global_position = global_position
	particles.reparent(get_tree().get_root())
	hit_sfx.hit()
	hit_sfx.reparent(get_tree().get_root())
	queue_free()

# Deletes projectile when it exits the screen.
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if !hasHit:
		if area.has_method("hurt"):
			area.hurt("hurt")
			hasHit = true
			hit_sfx.hit()
			hit_sfx.reparent(get_tree().get_root())
			hit()
