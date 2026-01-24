extends Node3D


@export var action_key = ""
@export var rocket: PackedScene
@export var cooldown = 1
var cooldown_left=0

func doAbility():
	cooldown_left = cooldown
	var inst: Node3D = rocket.instantiate()
	inst.position = global_position + Vector3(0, 2,0)
	inst.rotation = global_rotation
	get_node("/root").add_child(inst)
	


func _process(delta: float) -> void:
	cooldown_left -= delta
	
	if Input.is_action_pressed(action_key) and cooldown_left < 0:
		doAbility()
