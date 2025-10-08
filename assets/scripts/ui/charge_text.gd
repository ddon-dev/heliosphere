extends Label

@onready var text_colors: AnimationPlayer = $textColors

func _process(_delta: float) -> void:
	if GameManager.ultChargeable:
		text_colors.play("charging")
	elif GameManager.ultReady:
		text_colors.play("charge_full")		
		
	if !GameManager.ultChargeable and !GameManager.ultReady:
		text_colors.play("charge_cd")
