extends Node2D

@export var fire_particles: GPUParticles2D
@export var smoke_particles: GPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fire_particles.one_shot = true
	fire_particles.restart()
	smoke_particles.one_shot = true
	smoke_particles.restart()
	await fire_particles.finished
	await smoke_particles.finished
	queue_free()
