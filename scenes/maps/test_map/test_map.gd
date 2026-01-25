extends Node

func consume_next_spawn_point() -> Node3D:
	return $Spawn1

func get_spawn_points() -> Array[Node3D]:
	return [null]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
