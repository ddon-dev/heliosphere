extends Control

@export var spreadSprite: TextureRect
@export var pierceSprite: TextureRect
@onready var lives_label: Label = %livesNumber

func _ready() -> void:
	# Sets PowerUp Status to invisble.
	spreadSprite.visible = false
	pierceSprite.visible = false
	# Connects to update the amount of lives
	GameManager.lifeUpdate.connect(lives_updated)
	lives_label.set_lives_number(GameManager.lives)
	
func lives_updated(lives: int) -> void:
	lives_label.set_lives_number(lives)

func _process(_delta: float) -> void:
	if GameManager.hasPierce:
		pierceSprite.visible = true
		spreadSprite.visible = false
	elif GameManager.hasSpread:
		pierceSprite.visible = false
		spreadSprite.visible = true
	else:
		pierceSprite.visible = false
		spreadSprite.visible = false
