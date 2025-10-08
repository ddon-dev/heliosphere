extends Node

# Player-related variables
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

## Win - Lose
var victory: bool = false
var game_over: bool = false

# Signals
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

var life_down:= Timer.new()

func _ready():
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
