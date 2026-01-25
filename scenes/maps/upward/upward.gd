extends Node3D

@export var SpawnList : Array[Node3D]

func quick_func_thing(idx) -> Node3D:
	return SpawnList[idx % SpawnList.size()]

func consume_next_spawn_point() -> Node3D:
	return null
	#return quick_func_thing(idx)

func get_spawn_points() -> Array[Node3D]:
	return [null]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
