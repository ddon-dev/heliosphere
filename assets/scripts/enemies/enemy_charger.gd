extends CharacterBody2D

class_name enemyCharger

# Resources
@export var animationMain: AnimationPlayer
@export var hurtbox: Area2D
@export var particles: GPUParticles2D
@export var sfx_death: AudioStreamPlayer2D
@export var charge_start: Timer
@export var spawnMove: Timer
const EXPLOSION = preload("uid://cqpueb1norky")

# Enemy properties
@export var spawn_speed: float = 100
@export var charge_speed: float = 10
@export var charging: bool = false

# Death config
@export var death_rotation: float = 10
@export var rotation_direction = [5,-5].pick_random()
@export var death_slow: float = 1000
@export var death_direction: int = [2,-2].pick_random()

@export var isAlive: bool = true

func _ready() -> void:
	charge_start.timeout.connect(self.charge)
	spawnMove.timeout.connect(movement_countdown)
	hurtbox.area_entered.connect(dead)
	spawnMove.start()
		
func _physics_process(delta: float) -> void:
	if isAlive:
		if !spawnMove.is_stopped():
			velocity = Vector2(0,spawn_speed)
			move_and_slide()
		if charging:
			velocity += Vector2(0, charge_speed)
			move_and_slide()
	else:
		velocity = velocity.move_toward(Vector2.ZERO, delta * death_slow)
		rotation = rotate_toward(rotation, (rotation + rotation_direction), delta * death_rotation)
		move_and_slide()
		
func movement_countdown():
	charge_start.start()

func charge():
	print ("Charge!")
	charging = true

# Deletes enemy when it exits the screen, only if charging
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if isAlive and charging:
		queue_free()
		
func dead(_dead):
	sfx_death.play()
	isAlive = false
	# Slow rotation tween
	create_tween().tween_property(self,
	"rotation",
	PI * 5.0,
	1.2
	).as_relative().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	# Direction curve tween
	create_tween().tween_property(self,
	"velocity",
	Vector2(death_direction,0) * 100,
	1
	).as_relative().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	animationMain.play("dead")
	await animationMain.animation_finished
	var explosion = EXPLOSION.instantiate()
	get_parent().add_child(explosion)
	explosion.global_position = global_position
	explosion.reparent(get_tree().get_root())
	particles.emitting = true
	particles.reparent(get_tree().get_root())
	queue_free()
