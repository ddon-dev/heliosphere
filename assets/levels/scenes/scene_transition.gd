extends Control

@export var animation: AnimationPlayer
@export var fade_color: ColorRect

func fade_in():
	fade_color.color = Color(0.0, 0.0, 0.0, 1.0)
	animation.play("fade_in")
	
func fade_out():
	fade_color.color = Color(0.0, 0.0, 0.0, 1.0)
	animation.play("fade_out")
