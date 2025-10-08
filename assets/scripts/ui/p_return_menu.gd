extends Panel

@export var prevOptions: VBoxContainer
@export var yes: Button
@export var no: Button
@export var sfx_pressed: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
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
