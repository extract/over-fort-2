extends Area3D
class_name CaptureZone

var progress: float = 0
var max_progress: float = 5
var controller: int = 0

func _process(delta: float) -> void:
	if controller > 0:
		progress += delta
	elif controller < 0:
		progress -= delta
	
	if progress > max_progress:
		print("team 1 won")
	if progress < -max_progress:
		print("team 2 won")


func _on_body_entered(body: Node3D) -> void:
	if "team" in body:
		print("enterer",body.team)
		controller += body.team


func _on_body_exited(body: Node3D) -> void:
	if "team" in body:
		print("exit" ,body.team)
		controller -= body.team
