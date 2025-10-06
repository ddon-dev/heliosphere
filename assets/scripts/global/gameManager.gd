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

# Signals
signal lifeUpdate(life_update)
signal ultDone
signal oneUpGet
signal lasGet
signal sprGet

var life_down:= Timer.new()

func _ready():
	add_child(life_down)
	life_down.one_shot = true
	life_down.wait_time = 0.2

func player_death():
	life_down.start()
	await life_down.timeout
	lives -= 1
	lifeUpdate.emit(lives)
	hasPierce = false
	hasSpread = false
		
func life_gain():
	lives += 1
	lifeUpdate.emit(lives)

func ult_finished():
	ultDone.emit()
