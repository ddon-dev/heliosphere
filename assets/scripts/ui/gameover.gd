extends Panel

@export var retry_stage: Button
@export  var return_menu: Button
@export  var exit: Button
@export var currentMenu: VBoxContainer
@export var returnMenuChoice: VBoxContainer
@export var exitGameChoice: VBoxContainer
@export var sfx_pressed: AudioStreamPlayer
@export var music: AudioStreamPlayer
@onready var level_music: AudioStreamPlayer = $"../../../../music/level_music"
@onready var boss_music: AudioStreamPlayer = $"../../../../music/boss_music"


func _input(event: InputEvent) -> void:
	if visible:
		checkInput()

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
	if !checkInputDevice.isMouse:
		%deadMenuNo.grab_focus()
	
func exit_game():
	sfx_pressed.play()
	currentMenu.visible = false
	exitGameChoice.set_process(true)
	exitGameChoice.visible = true
	if !checkInputDevice.isMouse:
		%deadExitNo.grab_focus()
	
func start():
	GameManager.canPause = false
	level_music.stop()
	boss_music.stop()
	visible = true
	get_tree().paused = true
	music.play()
	
func checkInput():
	if checkInputDevice.get_input_type():
		if Input.mouse_mode != Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			get_viewport().gui_release_focus()
			for button in get_tree().get_nodes_in_group("Buttons"):
				if button is Button or OptionButton or HSlider:
					button.mouse_filter = 0
	elif Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		retry_stage.grab_focus()
		for button in get_tree().get_nodes_in_group("Buttons"):
			if button is Button or OptionButton or HSlider:
				button.mouse_filter = 2

func _on_v_box_container_visibility_changed() -> void:
	if visible && !checkInputDevice.isMouse:
		retry_stage.grab_focus()
