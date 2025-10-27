extends PanelContainer

@onready var scene_transition: AnimationPlayer = %sceneTransition/animation
@onready var scene_transition_color: ColorRect = %sceneTransition/fadeColor
@export var currentMenu: VBoxContainer
@export var opt_menu: PanelContainer
@onready var load_game: Button = %load_game
@onready var new_game: Button = %newGame
@onready var options: Button = %options
@onready var exit: Button = %exit
@export var level_music = AudioStreamPlayer
@export var sfx_pressed: AudioStreamPlayer

func _input(event: InputEvent) -> void:
	if visible:
		checkInput()

func focus_first_button():
	if %load_game.visible:
		if is_instance_valid(%load_game) and %load_game.is_inside_tree():
			%load_game.grab_focus()
	else:
		if is_instance_valid(%newGame) and %newGame.is_inside_tree():
			%newGame.grab_focus()
		

func _ready() -> void:
	get_tree().paused = false
	AudioServer.set_bus_effect_enabled(1,0,false)
	scene_transition_color.color = Color(0.0, 0.0, 0.0, 1.0)
	scene_transition.play("fade_in")
	await scene_transition.animation_finished
	load_game.pressed.connect(continue_game)
	new_game.pressed.connect(start_game)
	options.pressed.connect(options_open)
	exit.pressed.connect(exit_game)
	
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
		call_deferred("focus_first_button")
		for button in get_tree().get_nodes_in_group("Buttons"):
			if button is Button or OptionButton or HSlider:
				button.mouse_filter = 2

func continue_game():
	sfx_pressed.play()
	music_fade_out()
	scene_transition_color.color = Color(0.0, 0.0, 0.0, 1.0)
	scene_transition.play("fade_out")
	await scene_transition.animation_finished

func start_game():
	sfx_pressed.play()
	music_fade_out()
	scene_transition_color.color = Color(0.0, 0.0, 0.0, 1.0)
	scene_transition.play("fade_out")
	await scene_transition.animation_finished
	LevelManager.go_to_init_level()

func options_open():
	sfx_pressed.play()
	opt_menu.visible = true
	currentMenu.visible = false
	if !checkInputDevice.isMouse:
		%resolution.grab_focus()
	
func exit_game():
	sfx_pressed.play()
	music_fade_out()
	scene_transition_color.color = Color(0.0, 0.0, 0.0, 1.0)
	scene_transition.play("fade_out")
	await scene_transition.animation_finished
	get_tree().quit()

func music_fade_out():
	var fade_out = get_tree().create_tween()
	fade_out.tween_property(
		level_music,
		"volume_db",
		-150,
		7
	)


func _on_v_box_container_visibility_changed() -> void:
	if visible && !checkInputDevice.isMouse:
		call_deferred("focus_first_button")
	elif visible && checkInputDevice.isMouse:
		pass
