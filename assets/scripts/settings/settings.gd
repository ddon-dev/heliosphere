extends PanelContainer


@export var prevOptions: VBoxContainer
@export var sfx_pressed: AudioStreamPlayer
@onready var accept: Button = %accept
@onready var _return: Button = %return

func _ready() -> void:
	accept.pressed.connect(apply_options)
	
func _input(event: InputEvent) -> void:
	if visible:
		checkInput()
	if GameManager.canPause:
		if event.is_action_pressed("pause") or event.is_action_pressed("cancel"):
				sfx_pressed.play()
				visible = false
				GameManager.load_settings()
				prevOptions.visible = true

func apply_options():
	sfx_pressed.play()
	prevOptions.visible = true
	visible = false
	GameManager.save_settings()
	
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
		%resolution.grab_focus()
		for button in get_tree().get_nodes_in_group("Buttons"):
			if button is Button or OptionButton or HSlider:
				button.mouse_filter = 2


func _on_visibility_changed() -> void:
	if visible && !checkInputDevice.isMouse:
		checkInput()
		%accept.grab_focus()
