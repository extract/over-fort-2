extends Node3D


@export var speed = 10


func _process(delta: float) -> void:
	position -= transform.basis.z * speed * delta
	

func _on_body_entered(_body: Node) -> void:
	pass # Replace with function body.
