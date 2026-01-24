extends Node3D


@export var action_key = ""
@export var rocket: PackedScene


func doAbility():
	print("rocket launched")
	var inst: Node3D = rocket.instantiate()
	inst.position = global_position + Vector3(0, 2,0)
	inst.rotation = global_rotation
	get_node("/root").add_child(inst)
	


func _process(_delta: float) -> void:
	if Input.is_action_pressed(action_key):
		doAbility()
