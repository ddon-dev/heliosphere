extends ProgressBar


@export var health_drag: Timer
@export var damageBar: ProgressBar

var health = 0: set = _set_health

func _set_health(new_health):
	var prev_health = health
	health = min(max_value,new_health)
	value = health

	if health <= 0:
		queue_free()
	
	if health < prev_health:
		health_drag.start()
	else:
		damageBar.value = health

func init_hp(_hp):
	health = _hp
	max_value = health
	value = health
	damageBar.max_value = health
	damageBar.value = health
		
func _process(_delta: float) -> void:
	if health_drag.is_stopped():
		damageBar.value = move_toward(damageBar.value,health,5)
