extends CanvasLayer

@export var start_fadein: Timer
@onready var tutorial: AnimationPlayer = $main/tutorial
var tutorial_finished: bool = false


func _ready() -> void:
	GameManager.ultChargeable = false
	start_fadein.timeout.connect(start_tutorial)


func start_tutorial():
	tutorial.play("movement_and_shoot")
	await tutorial.animation_finished
	tutorial.play("slow_and_speed")
	await tutorial.animation_finished
	tutorial.play("ult")
	await tutorial.animation_finished
	GameManager.ultChargeable = true
	tutorial_finished = true
