extends Node2D

@onready var sfx_picked_up: AudioStreamPlayer = $AudioStreamPlayer
@onready var area_2d: Area2D = $Sprite2D/Area2D
@export var fall_speed: int = 1


func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	position += Vector2(0, fall_speed)
	
func _on_area_2d_body_entered(_body: Node2D) -> void:
	sfx_picked_up.life_get()
	sfx_picked_up.reparent(get_tree().get_root())
	GameManager.life_gain()
	GameManager.oneUpGet.emit()
	queue_free()
	
