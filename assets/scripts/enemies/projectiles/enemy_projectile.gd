extends Node2D

@onready var time_til_deletion: Timer = $time_til_deletion

@export_range(50, 3000, 5) var speed: float = 3000
@export var direction: Vector2 = Vector2.DOWN
@export var particles: GPUParticles2D

func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

# Deletes projectile when it exits the screen.
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	time_til_deletion.start()
	await time_til_deletion.timeout
	queue_free()

# If the Ultimate/Super Attack collides with it, the projectile is deleted
func _on_delete_zone_area_entered(_area: Area2D) -> void:
	queue_free()
