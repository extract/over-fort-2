extends Node3D


@export var action_key = "e"
@export var projectile: PackedScene

@export var cooldown = 2
var remaining_cooldown = 0

func doAction():
	remaining_cooldown = cooldown
	var inst = projectile.instantiate()
	inst.transform = (%Crosshair as Node3D).global_transform
	get_node("/root").add_child(inst)

func _process(delta: float) -> void:
	remaining_cooldown -= delta
	
	if Input.is_action_just_pressed("e") and remaining_cooldown < 0:
		doAction()
