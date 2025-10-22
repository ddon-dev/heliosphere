extends Node

#region Player related variables
## Lives
var playerRespawning: bool = false
var playerDying: bool = false
var playerHurtable: bool = true
var playerMoveable: bool = true
var lives: int = 3

## Power-Ups and Super Attacks
var canShoot: bool = true
var hasPierce: bool = false
var hasSpread: bool = false
var ultReady: bool = false
var ultChargeable: bool = true
@export_range(0,100,1) var ultCharge: int = 0
#endregion

#region Menus
var canPause: bool = true

## Win - Lose
var victory: bool = false
var game_over: bool = false
#endregion

#region Settings
const GAME_SETTINGS_PATH = "user://game_settings.tres"
var game_settings: GameSettings
const MODES = {
"Fullscreen": Window.MODE_FULLSCREEN,
"Windowed": Window.MODE_WINDOWED,
}
var current_screen = DisplayServer.window_get_current_screen()
var def_res = DisplayServer.screen_get_size(current_screen)
enum AUDIOBUS {
	master = 0,
	music = 1,
	sfx = 2,
}
var def_vol: float = 0.75
#endregion

#region Signals
signal lifeUpdate(life_update)
signal enemyHit
signal enemyExploded
signal ultFiring
signal playerExploding
signal playerExploded
signal ultDone
signal oneUpGet
signal lasGet
signal sprGet
signal gameOver
signal win
signal bossHalfHealth
signal boss_dead
#endregion

var life_down:= Timer.new()

func _ready():
	if ResourceLoader.exists(GAME_SETTINGS_PATH):
		game_settings = load(GAME_SETTINGS_PATH)
		apply_settings(game_settings)
	else:
		game_settings = GameSettings.new()
		ResourceSaver.save(game_settings, GAME_SETTINGS_PATH)
		load_default_settings()
	add_child(life_down)
	life_down.one_shot = true
	life_down.wait_time = 0.2
	LevelManager.level_changed.connect(func(_level): self.reset_state())

func player_death():
	life_down.start()
	await life_down.timeout
	lives -= 1
	lifeUpdate.emit(lives)
	hasPierce = false
	hasSpread = false
	if lives < 0:
		GameManager.game_over = true
		gameOver.emit()
		
func life_gain():
	lives += 1
	lifeUpdate.emit(lives)
	
func reset_lives():
	lives = 3

func ult_finished():
	ultDone.emit()
	
func reset_state():
	AudioServer.set_bus_effect_enabled(1,0,false)
	ultCharge = 0
	hasPierce = false
	hasSpread = false
	playerHurtable = true
	playerDying = false
	playerRespawning = false
	victory = false
	game_over = false
	reset_lives()
	
func reset_pwrUps():
	hasPierce = false
	hasSpread = false
	ultCharge = 0

func load_default_settings():
	get_window().size = def_res
	get_window().move_to_center()
	AudioServer.set_bus_volume_linear(AUDIOBUS.master, def_vol)
	AudioServer.set_bus_volume_linear(AUDIOBUS.music, def_vol)
	AudioServer.set_bus_volume_linear(AUDIOBUS.sfx, def_vol)
	get_window().mode = Window.MODE_FULLSCREEN

func save_settings():
	ResourceSaver.save(game_settings, GAME_SETTINGS_PATH)

func load_settings():
	ResourceLoader.load(GAME_SETTINGS_PATH)
	game_settings = load(GAME_SETTINGS_PATH)
	apply_settings(game_settings)
	
func apply_settings(game_settings: GameSettings):
	AudioServer.set_bus_volume_linear(AUDIOBUS.master, game_settings.master_volume)
	AudioServer.set_bus_volume_linear(AUDIOBUS.music, game_settings.music_volume)
	AudioServer.set_bus_volume_linear(AUDIOBUS.sfx, game_settings.sfx_volume)
	GameManager.game_settings.screen_mode = get_window().mode
	GameManager.game_settings.resolution = get_window().size
