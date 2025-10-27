extends VBoxContainer

@onready var scene_transition: AnimationPlayer = $"../../../../../../vfx/sceneTransition/animation"
@onready var scene_transition_color: ColorRect = $"../../../../../../vfx/sceneTransition/fadeColor"
@export var prevOptions: VBoxContainer
@export var yes: Button
@export var no: Button
@export var sfx_pressed: AudioStreamPlayer

func _input(event: InputEvent) -> void:
	if visible:
		checkInput()

func _ready() -> void:
	visible = false
	yes.pressed.connect(reset)
	no.pressed.connect(cancel)
	set_process(false)
	
func reset():
	sfx_pressed.play()
	get_tree().paused = false
	LevelManager.restart_level()
	pass

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
