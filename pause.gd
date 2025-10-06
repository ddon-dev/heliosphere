extends Control
@export var sfx_paused: AudioStreamPlayer
@export var sfx_pressed: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		sfx_paused.play()
		visible = !visible
		get_tree().paused = !get_tree().paused

func continue_game():
	pass

func options_open():
	pass

func go_to_menu():
	pass

func exit_game():
	pass
