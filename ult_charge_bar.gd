extends TextureProgressBar

@export var charge_fill_animations: AnimationPlayer
@export var time_add_charge: Timer

func _ready() -> void:
	time_add_charge.timeout.connect(timeAddCharge)

func _process(_delta: float) -> void:
	value = GameManager.ultCharge
	if GameManager.ultChargeable:
		charge_fill_animations.play("charging")
	
	if GameManager.ultReady:
		charge_fill_animations.play("charge_full")
		
	if GameManager.ultCharge >= 100:
		GameManager.ultReady = true
		GameManager.ultChargeable = false
	else:
		GameManager.ultReady = false
	
	if !GameManager.ultChargeable and !GameManager.ultReady:
		charge_fill_animations.play("charge_cd")

func timeAddCharge():
	if GameManager.ultChargeable and GameManager.ultCharge < 100:
			GameManager.ultCharge += 2
