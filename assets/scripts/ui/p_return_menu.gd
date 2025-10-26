extends VBoxContainer

@export var prevOptions: VBoxContainer
@export var yes: Button
@export var no: Button
@export var sfx_pressed: AudioStreamPlayer
@onready var resume: Button = %resume

func _input(event: InputEvent) -> void:
	checkInput()

func _ready() -> void:
	visible = false
	yes.pressed.connect(go_menu)
	no.pressed.connect(cancel)
	set_process(false)
	
func go_menu():
	sfx_pressed.play()
	LevelManager.go_to_menu()

func cancel():
	sfx_pressed.play()
	prevOptions.visible = true
	visible = false
	set_process(false)

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
		if visible:
			no.grab_focus()
		for button in get_tree().get_nodes_in_group("Buttons"):
			if button is Button or OptionButton or HSlider:
				button.mouse_filter = 2
