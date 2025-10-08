extends Panel

@export var prevOptions: VBoxContainer
@export var yes: Button
@export var no: Button
@export var sfx_pressed: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
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
