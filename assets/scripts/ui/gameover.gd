extends Control

@export var retry_stage: Button
@export  var return_menu: Button
@export  var exit: Button
@export var currentMenu: BoxContainer
@export var returnMenuChoice: Panel
@export var exitGameChoice: Panel
@export var sfx_pressed: AudioStreamPlayer
@export var music: AudioStreamPlayer
@onready var level_music: AudioStreamPlayer = get_tree().get_first_node_in_group("music")

func _ready() -> void:
	retry_stage.pressed.connect(restart_level)
	return_menu.pressed.connect(go_to_menu)
	exit.pressed.connect(exit_game)
	GameManager.gameOver.connect(start)

func restart_level():
	sfx_pressed.play()
	get_tree().paused = false
	GameManager.reset_state()
	LevelManager.restart_level()

func go_to_menu():
	sfx_pressed.play()
	currentMenu.visible = false
	returnMenuChoice.set_process(true)
	returnMenuChoice.visible = true
	

func exit_game():
	sfx_pressed.play()
	currentMenu.visible = false
	exitGameChoice.set_process(true)
	exitGameChoice.visible = true
	
func start():
	level_music.stop()
	visible = true
	get_tree().paused = true
	music.play()
