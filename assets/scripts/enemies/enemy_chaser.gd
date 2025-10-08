extends CharacterBody2D

# Resources
@export var animationMain: AnimationPlayer
@export var animationVFX: AnimationPlayer
@export var particles: GPUParticles2D
@export var sfx_death: AudioStreamPlayer2D
@export var hurtbox: Area2D
const EXPLOSION = preload("uid://cqpueb1norky")

# Item drops
const _1UP_ = preload("uid://bv1ppn50m8du0")
const LAS_ITEM = preload("uid://dgcqysipmy8l0")
const SPR_ITEM = preload("uid://cq7wuaqlu02al")


# Checks for the Player in the scene, sets as target
@onready var target: Node2D = get_tree().get_first_node_in_group("Player")

# Bool to only act when alive
@export var isAlive: bool = true

# Enemy properties
@export_range(50, 300, 1) var speed = 300

# Death config
@export var death_rotation: float = 10
@export var rotation_direction = [5,-5].pick_random()
@export var death_slow: float = 200
@export var death_direction: int = [2,-2].pick_random()



func _ready() -> void:
	hurtbox.area_entered.connect(dead)

func _physics_process(delta: float) -> void:
	if is_instance_valid(target):
		if target.visible && !GameManager.playerDying:
			if isAlive:
				var direction = (target.global_position-global_position).normalized()
				velocity = lerp(velocity, direction * speed, 8.5*delta)
				look_at(target.global_position)
				move_and_slide()
			else:
				velocity = velocity.move_toward(Vector2.ZERO, delta * death_slow)
				rotation = rotate_toward(rotation, (rotation + rotation_direction), delta * death_rotation)
				move_and_slide()
		else:
			velocity = velocity.move_toward(Vector2.ZERO, delta * 300)
			move_and_slide()

func dead(_dead):
	var item_drop: int = randi_range(0,100)
	var oneUp_drop: int = randi_range(0,100)
	sfx_death.play()
	isAlive = false
	# Slow rotation tween
	create_tween().tween_property(self,
	"rotation",
	PI * 5.0,
	1
	).as_relative().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	# Direction curve tween
	create_tween().tween_property(self,
	"velocity",
	Vector2(death_direction,0) * 100,
	0.7
	).as_relative().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	animationMain.play("dead")
	await animationMain.animation_finished
	GameManager.enemyExploded.emit()
	var explosion = EXPLOSION.instantiate()
	get_parent().add_child(explosion)
	explosion.global_position = global_position
	explosion.reparent(get_tree().get_root())
	if item_drop <= 15:
		var item_type: int = randi_range(0,50)
		if item_type >= 50:
			var las_item = LAS_ITEM.instantiate()
			get_parent().add_child(las_item)
			las_item.global_position = global_position
			las_item.reparent(get_tree().get_root())
		else:
			var spr_item = SPR_ITEM.instantiate()
			get_parent().add_child(spr_item)
			spr_item.global_position = global_position
			spr_item.reparent(get_tree().get_root())
	if oneUp_drop <= 5:
		var _1up = _1UP_.instantiate()
		get_parent().add_child(_1up)
		_1up.global_position = global_position
		_1up.reparent(get_tree().get_root())
	particles.emitting = true
	particles.reparent(get_tree().get_root())
	queue_free()
