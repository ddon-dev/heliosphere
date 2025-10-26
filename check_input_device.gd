extends Node
class_name checkInputDevice

static var isMouse = true

func _input(event: InputEvent) -> void:
	if (event is InputEventMouseMotion or event is InputEventMouseButton) or event is InputEventKey:
		isMouse = true
		
	elif event is InputEventJoypadButton or (event is InputEventJoypadMotion && deadzone_check()):
		isMouse = false
		
func deadzone_check():
	var deadzone = 0.5
	var joystick_vector = Vector2(Input.get_joy_axis(0, 0), -Input.get_joy_axis(0, 1)).length()
	return deadzone <  joystick_vector

static func get_input_type():
	return isMouse
