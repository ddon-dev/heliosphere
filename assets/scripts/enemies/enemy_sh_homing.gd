extends CharacterBody2D

class_name enemyShHoming

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
@export var sfx_charge_shot: AudioStreamPlayer2D
@export var sfx_fire: AudioStreamPlayer2D
@export var sfx_death: AudioStreamPlayer2D
@export var particles: GPUParticles2D
@export var healthbar: ProgressBar
const EXPLOSION = preload("uid://dxtc0ogemg87v")

# Enemy properties
var can_shoot: bool = false
@export var spawn_speed: float = 200
@export_range(1,300,1) var hp: int = 100

# Death config
@export var isAlive: bool = true
@export var death_rotation: float = 10
@export var rotation_direction = [5,-5].pick_random()
@export var death_slow: float = 1000
@export var death_direction: int = [2,-2].pick_random()

# Item drops
const _1UP_ = preload("uid://bv1ppn50m8du0")
const LAS_ITEM = preload("uid://dgcqysipmy8l0")
const SPR_ITEM = preload("uid://cq7wuaqlu02al")

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

func hurt(_hurt):
	if hp <= 0 && isAlive:
		animationVFX.play("RESET")
		dead(dead)
	else:
		animationVFX.play("hurt")
		hp -= 20
	if is_instance_valid(healthbar):
		healthbar.health = hp
	
func dead(_dead):
	var item_drop: int = randi_range(0,100)
	var oneUp_drop: int = randi_range(0,100)
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
	GameManager.enemyExploded.emit()
	var explosion = EXPLOSION.instantiate()
	get_parent().add_child(explosion)
	explosion.global_position = global_position
	explosion.reparent(get_tree().get_root())
	if item_drop <= 15:
		var item_type: int = randi_range(0,50)
		if item_type >= 25:
			var las_item = LAS_ITEM.instantiate()
			get_parent().add_child(las_item)
			las_item.global_position = global_position
			las_item.reparent(get_tree().get_root())
		else:
			var spr_item = SPR_ITEM.instantiate()
			get_parent().add_child(spr_item)
			spr_item.global_position = global_position
			spr_item.reparent(get_tree().get_root())
	if oneUp_drop <= 2:
		var _1up = _1UP_.instantiate()
		get_parent().add_child(_1up)
		_1up.global_position = global_position
		_1up.reparent(get_tree().get_root())
	particles.emitting = true
	particles.reparent(get_tree().get_root())
	queue_free()
