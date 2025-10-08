extends Node2D


signal boss
@export var warning_anim: AnimationPlayer
@export var bg_anim: AnimationPlayer
@export var alarm: AudioStreamPlayer
@onready var level_music: AudioStreamPlayer = %level_music
@onready var boss_music: AudioStreamPlayer = %boss_music
@export var warning: Sprite2D
@export var tutorial: CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	boss.connect(boss_start)
	pass # Replace with function body.


#func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("shoot"):
		#boss.emit()
	

func boss_start():
		level_music.stop()
		warning.visible = true
		alarm.play()
		warning_anim.play("default")
		bg_anim.play("boss_darken")
		await alarm.finished
		warning.visible = false
		warning_anim.stop()
