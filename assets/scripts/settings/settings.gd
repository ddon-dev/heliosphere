extends PanelContainer


@export var prevOptions: VBoxContainer
@export var sfx_pressed: AudioStreamPlayer
@onready var accept: Button = %accept
@onready var _return: Button = %return

func focus_first_button():
	%resolution.grab_focus()

func _ready() -> void:
	accept.pressed.connect(apply_options)
	
func _input(event: InputEvent) -> void:
	if GameManager.canPause:
		if event.is_action_pressed("pause") or event.is_action_pressed("cancel"):
			if visible:
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
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	


func _on_visibility_changed() -> void:
	if visible && !checkInputDevice.isMouse:
		checkInput()
		%accept.grab_focus()
	elif visible && checkInputDevice.isMouse:
		pass
