extends CharacterBody2D


@onready var target: Node2D = get_tree().get_first_node_in_group("Player")
@export_range(50, 300, 1) var speed = 300
@export var timeout_particles: GPUParticles2D
@export var hitbox: Area2D
@export var delete_zone: Area2D

	
func _physics_process(delta: float) -> void:
	# If there's a target, it'll chase it around
	if is_instance_valid(target):
		if target.visible && !GameManager.playerDying:
			var direction = (target.global_position-global_position).normalized()
			velocity = lerp(velocity, direction * speed, 8.5*delta)
			move_and_slide()
		else:
			velocity = velocity.move_toward(Vector2.ZERO, delta * 300)
			move_and_slide()

func _on_lifetime_timeout() -> void:
	if is_instance_valid(timeout_particles):
		timeout_particles.emitting = true
		timeout_particles.reparent(get_tree().get_root())
		queue_free()

# If the Ultimate/Super Attack collides with it, the projectile is deleted
func _on_delete_zone_area_entered(_area: Area2D) -> void:
	queue_free()
