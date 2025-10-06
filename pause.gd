extends Control

@onready var sfx: AudioStreamPlayer = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		sfx.play()
		visible = !visible
		get_tree().paused = !get_tree().paused
