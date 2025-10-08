extends CharacterBody2D

class_name player

#region Resources
# Resources
@onready var sprite: Sprite2D = $Sprite2D
@onready var hurtbox: Area2D = $hurtbox
@export var animation: AnimationPlayer
@export var animation_respawn: AnimationPlayer
@export var animation_vfx: AnimationPlayer
@export var charging_particles: GPUParticles2D
@onready var projectiles: Node2D = $projectiles
@onready var ult_attack: Node2D = $projectiles/ultSpawn
@export var ult_cd: Timer
@export var sfx_shoot: AudioStreamPlayer2D
@export var sfx_ultCharge: AudioStreamPlayer2D
@export var sfx_ultFire: AudioStreamPlayer2D
@export var sfx_death: AudioStreamPlayer2D
@export var timeDying: Timer
@export var deathExplosionsTimer: Timer
@export var time_til_respawn: Timer
@export var respawn_invul: Timer
@export var pwrUpDuration: Timer
const EXPLOSION_SMALL = preload("uid://d0g0ojihflexi")
const EXPLOSION_BIG = preload("uid://3waql7gq5om3")
#endregion

# Signals
signal fire
signal ultFire

# Variables
## Movement
const def_speed: float = 500.0
@export_range(300, 1000, 1) var speed: float = def_speed
@export_range(100, 800, 1) var slow: float = 250.0
@export_range(100, 800, 1) var boost: float = 250.0
@export var moveSlow = false
@export var moveBoost = false
var ultPreFire: bool = false

## Combat
## Creates a CD timer based on the value set in fireRate
var shootCD:= Timer.new()
@export_range(0.11, 1, 0.05) var fireRate: float = 0.25

## Death and respawn variables
var default_rotation = 0
@onready var respawn_point: Marker2D = get_tree().get_first_node_in_group("RespawnPoint")
@export var death_slow = 100
@export var death_rotation: float = 10
@export var rotation_direction = [5,-5].pick_random()
@export var death_direction_x: int = [2,-2].pick_random()
@export var death_direction_y: int = [2,-2].pick_random()





func _ready() -> void:
	GameManager.ultDone.connect(ult_charge_cd)
	GameManager.oneUpGet.connect(life_get)
	GameManager.sprGet.connect(spr_get)
	GameManager.lasGet.connect(las_get)
	pwrUpDuration.timeout.connect(pwrUpTimeout)
	hurtbox.area_entered.connect(death)
	time_til_respawn.timeout.connect(respawn)
	deathExplosionsTimer.timeout.connect(death_explosions)
	add_child(shootCD)
	shootCD.one_shot = true

#region Movement and Shooting
func _physics_process(delta: float) -> void:
	
# Movement
	var direction_x := Input.get_axis("move_left", "move_right")
	var direction_y := Input.get_axis("move_up", "move_down")
	if !GameManager.playerDying:
		if GameManager.playerMoveable:
			if Input.is_action_just_pressed("move_slow"):
				speed -= slow
				moveSlow = true
			elif Input.is_action_just_released("move_slow"):
				speed = def_speed
				moveSlow = false
			if Input.is_action_just_pressed("move_fast"):
				speed += boost
				moveBoost = true
			elif Input.is_action_just_released("move_fast"):
				speed = def_speed
				moveBoost = false
				
			if direction_x:
				velocity.x = direction_x * speed
			else:
				velocity.x = move_toward(velocity.x, 0, speed)
			if direction_y:
				velocity.y = direction_y * speed
			else:
				velocity.y = move_toward(velocity.y, 0, speed)
			move_and_slide()
			
	# Prevents slow and boost to work at the same time. As slowing down shrinks the hurtbox,
	# this prevents players from getting the small hurtbox without bypassing the slower movement.
		if moveSlow and moveBoost:
			print("Nope")
			moveSlow = false
			moveBoost = false

	# Attacking
		if Input.is_action_pressed("shoot"):
			shoot()
		if Input.is_action_just_pressed("shoot_ult"):
			fire_ult()
			
	elif GameManager.playerDying:
			velocity = velocity.move_toward(Vector2.ZERO, delta * death_slow)
			rotation = rotate_toward(rotation, (rotation + rotation_direction), delta * death_rotation)
			move_and_slide()
#endregion

# Movement animations
func _process(_delta: float) -> void:
	if !GameManager.playerDying:
		if moveSlow:
			animation.play("slow")
		elif moveBoost:
			animation.play("boost")
		else:
			animation.play("default")
	if ultPreFire:
		GameManager.canShoot = false

#region Shooting logic
func shoot():
	if GameManager.canShoot:
		projectiles.fire()
		shootCD.wait_time = fireRate
		shootCD.start()
		GameManager.canShoot = false
		fire.emit()
		sfx_shoot.play()
		await shootCD.timeout
		GameManager.canShoot = true
		
func fire_ult():
	if GameManager.ultReady:
		GameManager.playerHurtable = false
		ultPreFire = true
		charging_particles.emitting = true
		animation_vfx.play("ult_charging")
		GameManager.ultReady = false
		GameManager.ultChargeable = false
		GameManager.canShoot = false
		ultFire.emit()
		sfx_ultCharge.play()
		await sfx_ultCharge.finished
		animation_vfx.play("RESET")
		sfx_ultFire.play()
		GameManager.ultFiring.emit()
		GameManager.ultCharge = 0
		ult_attack.fire()
		charging_particles.emitting = false
		ultPreFire = false
		
func ult_charge_cd():
	ult_cd.start()
	await ult_cd.timeout
	GameManager.ultChargeable = true
#endregion

#region Death and Respawn logic
# Death animations and behaviour
func death(_death):
	if GameManager.playerHurtable:
		death_explosions()
		deathExplosionsTimer.start()
		timeDying.start()
		animation.play("dead")
		sfx_death.play()
		GameManager.playerDying = true
		GameManager.ultChargeable = false
		# Slow rotation tween
		create_tween().tween_property(self,
		"rotation",
		PI * 2.0,
		1.45
		).as_relative().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
		# Direction curve tween
		create_tween().tween_property(self,
		"velocity",
		Vector2(death_direction_x,death_direction_y) * 100,
		1.3
		).as_relative().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
		await timeDying.timeout
		GameManager.playerExploded.emit()
		var big_boom = EXPLOSION_BIG.instantiate()
		get_parent().add_child(big_boom)
		big_boom.global_position = global_position
		big_boom.reparent(get_tree().get_root())
		deathExplosionsTimer.stop()
		visible = false
		await sfx_death.finished
		GameManager.player_death()
		if GameManager.lives >= 0:
			time_til_respawn.start()
	
func death_explosions():
	GameManager.playerExploding.emit()
	var small_boom = EXPLOSION_SMALL.instantiate()
	get_parent().add_child(small_boom)
	small_boom.global_position = global_position
	small_boom.reparent(get_tree().get_root())
# Makes the player invincible while respawning and making its sprite blink.
# Prevents charge gain while respawning.
func respawn():
	GameManager.canShoot = false
	GameManager.playerDying = false
	GameManager.playerRespawning = true
	respawn_invul.start()
	visible = true
	global_position = respawn_point.global_position
	rotation = default_rotation
	animation_respawn.play("respawning")
	await respawn_invul.timeout
	animation_respawn.play("RESET")
	GameManager.playerRespawning = false
	GameManager.ultChargeable = true
	GameManager.canShoot = true
#endregion

#region Pickup and related VFX
func life_get():
	if !ultPreFire:
		animation_vfx.play("life_up")
		await animation_vfx.animation_finished
		animation_vfx.play("RESET")
	
func las_get():
	pwrUpDuration.start()
	if !ultPreFire:
		animation_vfx.play("las_get")
		await animation_vfx.animation_finished
		animation_vfx.play("RESET")
	
func spr_get():
	pwrUpDuration.start()
	if !ultPreFire:
		animation_vfx.play("spr_get")
		await animation_vfx.animation_finished
		animation_vfx.play("RESET")

func pwrUpTimeout():
	if GameManager.hasPierce:
		GameManager.hasPierce = false
	elif GameManager.hasSpread:
		GameManager.hasSpread = false
#endregion
