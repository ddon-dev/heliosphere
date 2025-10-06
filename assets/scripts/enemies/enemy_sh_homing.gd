extends CharacterBody2D

class_name enemyShHoming

# Resources
@export var hurtbox: Area2D
@export var animationMain: AnimationPlayer
@export var shoot_anim: AnimationPlayer
@export var projectile_spawn: Marker2D
@export var projectile_type: PackedScene
@export var spawnMove: Timer
@export var shoot_cooldown: Timer
@export var charging_shot: Timer
@export var sfx_charge_shot: AudioStreamPlayer2D
@export var sfx_fire: AudioStreamPlayer2D
@export var sfx_death: AudioStreamPlayer2D
@export var particles: GPUParticles2D
@export var healthbar: ProgressBar
const EXPLOSION = preload("uid://dxtc0ogemg87v")

# Enemy properties
var can_shoot: bool = false
@export var spawn_speed: float = 100
@export_range(1,300,1) var hp: int = 100
@export var isAlive: bool = true

# Death config
@export var death_rotation: float = 10
@export var rotation_direction = [5,-5].pick_random()
@export var death_slow: float = 1000
@export var death_direction: int = [2,-2].pick_random()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	healthbar.init_hp(hp)
	hurtbox.area_entered.connect(hurt)
	shoot_cooldown.timeout.connect(shoot_charge)
	charging_shot.timeout.connect(fire)
	spawnMove.start()

func _process(delta: float) -> void:
	if isAlive:
		if !spawnMove.is_stopped():
			velocity = Vector2(0,spawn_speed)
			move_and_slide()
			shoot_cooldown.start()
	else:
		velocity = velocity.move_toward(Vector2.ZERO, delta * death_slow)
		rotation = rotate_toward(rotation, (rotation + rotation_direction), delta * death_rotation)
		move_and_slide()

func shoot_charge():
	if isAlive:
		print ("Charging...")
		can_shoot = true
		shoot_anim.play("charging")
		sfx_charge_shot.play()
		charging_shot.start()
	
func fire():
	if isAlive:
		can_shoot = false
		shoot_anim.play("RESET")
		sfx_fire.play()
		shoot_cooldown.start()
		var projectile = projectile_type.instantiate()
		projectile.position = projectile_spawn.global_position
		get_tree().root.call_deferred("add_child", projectile)
		print ("Fire!")

func hurt(_hurt):
	if hp <= 0 && isAlive:
		dead(dead)
	else:
		hp -= 20
	
	healthbar.health = hp
	
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
	shoot_anim.play("RESET")
	await animationMain.animation_finished
	var explosion = EXPLOSION.instantiate()
	get_parent().add_child(explosion)
	explosion.global_position = global_position
	explosion.reparent(get_tree().get_root())
	particles.emitting = true
	particles.reparent(get_tree().get_root())
	queue_free()
