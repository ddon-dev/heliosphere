extends PanelContainer


@export var prevOptions: VBoxContainer
@export var sfx_pressed: AudioStreamPlayer
@onready var accept: Button = %accept
@onready var _return: Button = %return

func _ready() -> void:
	accept.pressed.connect(apply_options)
	
func _input(event: InputEvent) -> void:
	if GameManager.canPause:
		if event.is_action_pressed("pause"):
			if visible:
				visible = false
				GameManager.load_settings()
				prevOptions.visible = true

func apply_options():
	sfx_pressed.play()
	prevOptions.visible = true
	visible = false
	GameManager.save_settings()
	
