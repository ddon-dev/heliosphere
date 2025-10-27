extends Control

@export var currentMenu: VBoxContainer
@export var returnMenuChoice: VBoxContainer
@export var retryLevelChoice: VBoxContainer
@export var exitGameChoice: VBoxContainer
@export var opt_menu: PanelContainer
@onready var paused: bool = false
@onready var resume: Button = %resume
@onready var options: Button = %options
@onready var retry_stage: Button = %retry_stage
@onready var return_menu: Button = %menu
@onready var exit: Button = %exit
@export var sfx_paused: AudioStreamPlayer
@export var sfx_pressed: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	resume.pressed.connect(continue_game)
	retry_stage.pressed.connect(restart_level)
	options.pressed.connect(options_open)
	return_menu.pressed.connect(go_to_menu)
	exit.pressed.connect(exit_game)
	visible = false
	

func _input(event: InputEvent) -> void:
	if visible:
		checkInput()
	if GameManager.canPause:
		if event.is_action_pressed("pause") or event.is_action_pressed("cancel"):
			paused = !paused
			sfx_paused.play()
			visible = !visible
			get_tree().paused = !get_tree().paused
		
		if paused:
			AudioServer.set_bus_effect_enabled(1,0,true)
		else:
			AudioServer.set_bus_effect_enabled(1,0,false)
			returnMenuChoice.visible = false
			returnMenuChoice.set_process(false)
			retryLevelChoice.visible = false
			retryLevelChoice.set_process(false)
			exitGameChoice.visible = false
			exitGameChoice.set_process(false)
			currentMenu.visible = true

func continue_game():
	AudioServer.set_bus_effect_enabled(1,0,false)
	get_tree().paused = !get_tree().paused
	sfx_paused.play()
	visible = !visible
	paused = !paused

func restart_level():
	currentMenu.visible = false
	retryLevelChoice.visible = true
	retryLevelChoice.set_process(true)
	if !checkInputDevice.isMouse:
		%retryLevelNo.grab_focus()

func options_open():
	sfx_pressed.play()
	opt_menu.visible = true
	currentMenu.visible = false
	if !checkInputDevice.isMouse:
		%resolution.grab_focus()

func go_to_menu():
	currentMenu.visible = false
	returnMenuChoice.set_process(true)
	returnMenuChoice.visible = true
	if !checkInputDevice.isMouse:
		%returnMenuNo.grab_focus()

func exit_game():
	currentMenu.visible = false
	exitGameChoice.set_process(true)
	exitGameChoice.visible = true
	if !checkInputDevice.isMouse:
		%exitGameNo.grab_focus()


func _on_v_box_container_visibility_changed() -> void:
	if visible && !checkInputDevice.isMouse:
		%resume.grab_focus()

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
		resume.grab_focus()
		for button in get_tree().get_nodes_in_group("Buttons"):
			if button is Button or OptionButton or HSlider:
				button.mouse_filter = 2
