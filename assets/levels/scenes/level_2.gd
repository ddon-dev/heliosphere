extends Node2D


signal boss
@export var warning_anim: AnimationPlayer
@export var bg_anim: AnimationPlayer
@export var alarm: AudioStreamPlayer
@onready var level_music: AudioStreamPlayer = %level_music
@onready var boss_music: AudioStreamPlayer = %boss_music
@export var warning: Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	boss.connect(boss_start)
	pass # Replace with function body.


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		boss.emit()
	
func music_fade_out():
	var volume = level_music.volume_db
	var fade_out = get_tree().create_tween()
	fade_out.tween_property(
		level_music,
		"volume_db",
		-80,
		7
	)
	fade_out.tween_callback(music_off)

func music_off():
	level_music.stop()

func boss_start():
		music_fade_out()
		warning.visible = true
		alarm.play()
		warning_anim.play("default")
		bg_anim.play("boss_darken")
		await alarm.finished
		warning.visible = false
		warning_anim.stop()
		boss_music.play()
