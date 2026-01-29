extends Camera3D

var mouse_sensitivity:float = 0.01

func _unhandled_input(event: InputEvent) -> void:
	if(event is InputEventMouseMotion):
		var mouse_event: InputEventMouseMotion = event
		rotate_x(-mouse_event.relative.y * mouse_sensitivity)
		rotation.x = clamp(rotation.x, -PI/2, PI/2)
