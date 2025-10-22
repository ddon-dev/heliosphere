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
var gamepad_input: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	resume.pressed.connect(continue_game)
	retry_stage.pressed.connect(restart_level)
	options.pressed.connect(options_open)
	return_menu.pressed.connect(go_to_menu)
	exit.pressed.connect(exit_game)
	visible = false
	

func _input(event: InputEvent) -> void:
	if GameManager.canPause:
		if event.is_action_pressed("pause"):
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
			
	if event is InputEventJoypadMotion or event is InputEventJoypadButton:
		if !gamepad_input:
			gamepad_input = true
		else:
			gamepad_input = false

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

func options_open():
	sfx_pressed.play()
	opt_menu.visible = true
	currentMenu.visible = false
	pass

func go_to_menu():
	currentMenu.visible = false
	returnMenuChoice.set_process(true)
	returnMenuChoice.visible = true

func exit_game():
	currentMenu.visible = false
	exitGameChoice.set_process(true)
	exitGameChoice.visible = true
