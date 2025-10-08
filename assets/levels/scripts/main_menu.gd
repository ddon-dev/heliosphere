extends PanelContainer

@onready var load_game: Button = %load_game
@onready var new_game: Button = %newGame
@onready var options: Button = %options
@onready var exit: Button = %exit
@export var sfx_pressed: AudioStreamPlayer

func _ready() -> void:
	get_tree().paused = false
	AudioServer.set_bus_effect_enabled(1,0,false)
	load_game.pressed.connect(continue_game)
	new_game.pressed.connect(start_game)
	options.pressed.connect(options_open)
	exit.pressed.connect(exit_game)
	
func continue_game():
	sfx_pressed.play()
	pass

func start_game():
	sfx_pressed.play()
	LevelManager.go_to_init_level()
	pass

func options_open():
	sfx_pressed.play()
	pass
	
func exit_game():
	sfx_pressed.play()
	get_tree().quit()
