extends CharacterBody2D


# Resources
@export var hurtbox: Area2D
@export var animationMain: AnimationPlayer
@export var animationVFX: AnimationPlayer
@export var shoot_anim: AnimationPlayer
@export var projectile_spawn: Marker2D
@export var projectile_type: PackedScene
@export var spawnMove: Timer
@export var shoot_cooldown: Timer
@export var charging_shot: Timer
@export var rateOfFire: Timer
@export var sfx_charge_shot: AudioStreamPlayer2D
@export var sfx_fire: AudioStreamPlayer2D
@export var sfx_death: AudioStreamPlayer2D
@export var particles: GPUParticles2D
@export var healthbar: ProgressBar
@onready var sprite: Sprite2D = $Sprite2D
const EXPLOSION = preload("uid://cuo1kj6h0eexp")

# Enemy properties
var can_shoot: bool = false
@export var spawn_speed: float = 100
@export var move_speed: float = 150
@export var direction: int = 1
@export_range(1,5000,1) var hp: int = 5000
var hurtable: bool = false
var second_phase: bool = false

# Death config
@export var isAlive: bool = true
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
	spawnMove.timeout.connect(stopped)

func _process(delta: float) -> void:
	var viewport_size = get_viewport().size
	var enemy_width = sprite.texture.get_width() * sprite.scale.x
	if isAlive:
		if !spawnMove.is_stopped():
			velocity = Vector2(0,spawn_speed)
			move_and_slide()
		elif spawnMove.is_stopped():
			velocity = Vector2(move_speed * direction, 0)
			if position.x > viewport_size.x - (enemy_width / 3):
				direction = -1
			if position.x < (enemy_width / 3):
				direction = 1
			move_and_slide()
	else:
		velocity = velocity.move_toward(Vector2.ZERO, delta * death_slow)
		rotation = rotate_toward(rotation, (rotation + rotation_direction), delta * death_rotation)
		move_and_slide()


func stopped():
	shoot_charge()
	shoot_cooldown.start()

func shoot_charge():
	if isAlive:
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
		rateOfFire.start()
		await rateOfFire.timeout
		sfx_fire.play()
		var projectile1 = projectile_type.instantiate()
		projectile1.position = projectile_spawn.global_position
		get_tree().root.call_deferred("add_child", projectile1)
		rateOfFire.start()
		await rateOfFire.timeout
		sfx_fire.play()
		var projectile2 = projectile_type.instantiate()
		projectile2.position = projectile_spawn.global_position
		get_tree().root.call_deferred("add_child", projectile2)

func hurt(_hurt):
	if hp <= 0 && isAlive:
		animationVFX.play("RESET")
		dead(dead)
	else:
		animationVFX.play("hurt")
		hp -= 20
	if hp <= 2500:
		if !second_phase:
			second_phase = true
			GameManager.bossHalfHealth.emit()
	if is_instance_valid(healthbar):
		healthbar.health = hp
		
func dead(_dead):
	sfx_death.play()
	isAlive = false
	# Slow rotation tween
	create_tween().tween_property(self,
	"rotation",
	PI * 5.0,
	2.5
	).as_relative().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	# Direction curve tween
	create_tween().tween_property(self,
	"velocity",
	Vector2(death_direction,10) * 100,
	1.5
	).as_relative().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	animationMain.play("dead")
	shoot_anim.play("RESET")
	await animationMain.animation_finished
	GameManager.boss_dead.emit()
	GameManager.enemyExploded.emit()
	var explosion = EXPLOSION.instantiate()
	get_parent().add_child(explosion)
	explosion.global_position = global_position
	explosion.reparent(get_tree().get_root())
	particles.emitting = true
	particles.reparent(get_tree().get_root())
	queue_free()
