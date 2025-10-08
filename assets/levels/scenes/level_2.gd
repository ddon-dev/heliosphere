extends Node2D

# Resources
@export var warning_anim: AnimationPlayer
@export var bg_anim: AnimationPlayer
@export var alarm: AudioStreamPlayer
@onready var level_music: AudioStreamPlayer = %level_music
@onready var boss_music: AudioStreamPlayer = %boss_music
@export var warning: Sprite2D
@export var time_til_fadeout: Timer
@export var time_til_victory: Timer
const PLAYER = preload("uid://ckog1nfv7gj1")
@onready var respawn_point: Marker2D = %"Respawn Point"

## Enemies
@export var enemy_charger: Node
@export var enemy_shooter: Node
@export var enemy_chaser: Node
@export var enemy_sh_homing: Node
@export var miniboss: Node


## Enemy Spawn Frequency
@export var chargerFreq: Timer
@export var shooterFreq: Timer
@export var chaserFreq: Timer
@export var shHomingFreq: Timer

## Stage duration
@export var level_start: Timer
@export var stage1_duration: Timer
@export var stage1_chaserSpawn: Timer
@export var stage2_duration: Timer
@export var stage3_duration: Timer
@export var boss_fight_duration: Timer
var boss_started: bool = false
var boss_in_progress: bool = false
var second_phase: bool = false
var boss_fight_ended: bool = false
var stage3_reached: bool = false
var finished_level: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var _player = PLAYER.instantiate()
	_player.position = respawn_point.position
	add_child(_player)
	level_start.timeout.connect(start_stage_1)
	stage1_duration.timeout.connect(start_stage_2)
	stage2_duration.timeout.connect(start_stage_3)
	stage3_duration.timeout.connect(stop_spawns)
	GameManager.bossHalfHealth.connect(start_second_phase)
	GameManager.boss_dead.connect(end_fight)
	chargerFreq.timeout.connect(spawn_charger)
	shooterFreq.timeout.connect(spawn_shooter)
	chaserFreq.timeout.connect(spawn_chaser)
	shHomingFreq.timeout.connect(spawn_sh_homing)
	time_til_victory.timeout.connect(victory_screen)
	time_til_fadeout.timeout.connect(next_level)

func _process(delta: float) -> void:
	if stage3_duration.is_stopped() && stage3_reached:
		if !boss_started:
				boss_start()
	if boss_in_progress:
		if boss_fight_ended && !finished_level:
			boss_fight_finish()
		

func start_stage_1():
	print("stage1")
	enemy_charger.spawn_charger()
	stage1_duration.start()
	stage1_chaserSpawn.start()
	chargerFreq.start()
	await stage1_chaserSpawn.timeout
	chaserFreq.start()
	

func start_stage_2():
	print("stage2")
	enemy_shooter.spawn_shooter()
	enemy_shooter.spawn_shooter()
	enemy_shooter.spawn_shooter()
	stage2_duration.start()
	shooterFreq.start()

func start_stage_3():
	print("stage3")
	stage3_duration.start()
	stage3_reached = true
	shHomingFreq.start()
	chargerFreq.wait_time = 1.5
	shooterFreq.wait_time = 7
	

func spawn_charger():
	enemy_charger.spawn_charger()
	enemy_charger.spawn_charger()
	enemy_charger.spawn_charger()
	enemy_charger.spawn_charger()
	enemy_charger.spawn_charger()

func spawn_shooter():
	enemy_shooter.spawn_shooter()
	enemy_shooter.spawn_shooter()
	enemy_shooter.spawn_shooter()
	enemy_shooter.spawn_shooter()
	
func spawn_chaser():
	enemy_chaser.spawn_chaser()
	enemy_chaser.spawn_chaser()
	enemy_chaser.spawn_chaser()
	enemy_chaser.spawn_chaser()
	enemy_chaser.spawn_chaser()
	enemy_chaser.spawn_chaser()

func spawn_sh_homing():
	enemy_sh_homing.spawn_sh_homing()
	enemy_sh_homing.spawn_sh_homing()
	
func stop_spawns():
	chargerFreq.stop()
	shooterFreq.stop()
	chaserFreq.stop()
	shHomingFreq.stop()

func boss_start():
	var enemies_array = get_tree().get_nodes_in_group("Enemies")
	var enemies_remaining = enemies_array.size()
	if enemies_remaining == 0:
		boss_started = true
		level_music.stop()
		warning.visible = true
		alarm.play()
		warning_anim.play("default")
		bg_anim.play("boss_darken")
		await alarm.finished
		boss_music.play()
		boss_in_progress = true
		warning.visible = false
		warning_anim.stop()
		miniboss.spawn_miniboss()

func end_fight():
	boss_fight_ended = true
	
func start_second_phase():
	chargerFreq.start()
	shooterFreq.start()
	
func boss_fight_finish():
	stop_spawns()
	var enemies_array = get_tree().get_nodes_in_group("Enemies")
	var enemies_remaining = enemies_array.size()
	if enemies_remaining == 0:
		finished_level = true
		boss_fade_out()
		time_til_victory.start()

func victory_screen():
	GameManager.win.emit()
	time_til_fadeout.start()

func next_level():
	LevelManager.go_to_next_level()
	
#region Music controls
func music_fade_out():
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
	
func boss_fade_out():
	var fade_out = get_tree().create_tween()
	fade_out.tween_property(
		boss_music,
		"volume_db",
		-80,
		7
	)
	fade_out.tween_callback(music_off)
#endregion
