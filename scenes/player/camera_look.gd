extends Camera3D

var mouse_sensitivity = 0.01

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_x(-event.relative.y * mouse_sensitivity)
		rotation.x = clamp(rotation.x, -PI/2, PI/2)
