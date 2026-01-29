extends Node3D
class_name UpwardMap

@export var SpawnList : Array[Node3D]

func quick_func_thing(idx:int) -> Node3D:
	return SpawnList[idx % SpawnList.size()]

func consume_next_spawn_point() -> Node3D:
	return null
	#return quick_func_thing(idx)

func get_spawn_points() -> Array[Node3D]:
	return [null]
