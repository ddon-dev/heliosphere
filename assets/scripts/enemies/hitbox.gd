extends Area2D

var hasHit = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_area_entered(area: Area2D) -> void:
	if area.has_method("death"):
		area.death("death")
