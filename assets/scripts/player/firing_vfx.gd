extends Node2D

# Resources
const normal = preload("uid://dmss5wocwye73")
const pierce = preload("uid://cskgbymgf6sx6")
const spread = preload("uid://dgffs6nvjdk14")

@export var vfx_fire: Sprite2D
@export var animation: AnimationPlayer
@export var ultCharging: Sprite2D
@export var chargeAnim: AnimationPlayer
@export var loop_duration: Timer

func _process(_delta: float) -> void:
	if GameManager.hasPierce:
		vfx_fire.set_texture(pierce)
	elif GameManager.hasSpread:
		vfx_fire.set_texture(spread)
	else:
		vfx_fire.set_texture(normal)

func _on_player_fire() -> void:
	animation.play("firing")
	animation.queue("RESET")

func _on_player_ult_fire() -> void:
	chargeAnim.play("charging")
	loop_duration.start()
	await loop_duration.timeout
	chargeAnim.play("RESET")
