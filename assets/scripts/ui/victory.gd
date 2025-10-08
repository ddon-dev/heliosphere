extends Control

@export var music: AudioStreamPlayer

func _ready() -> void:
	GameManager.win.connect(start)
	
func start():
	visible = true
	GameManager.canPause = false
	GameManager.victory = true
	music.play()
	await music.finished
