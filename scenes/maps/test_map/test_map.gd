class_name TestMapNode
extends Node

@export var spawn_list: Array[Node3D]


func quick_func_thing(idx: int) -> Node3D:
	return spawn_list[idx % spawn_list.size()]


func consume_next_spawn_point() -> Node3D:
	return null
	#return quick_func_thing(idx)


func get_spawn_points() -> Array[Node3D]:
	return [null]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.
