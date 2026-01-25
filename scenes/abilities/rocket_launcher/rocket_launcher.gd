extends Node3D


@export var action_key = ""
@export var rocket: PackedScene
@export var cooldown = 1.0
@export var spawnPoint : Node3D
var cooldown_left=0

func doAbility():
	cooldown_left = cooldown
	var inst: Node3D = rocket.instantiate()
	if null != get_node_or_null("Crosshair"):
		inst.transform = %Crosshair.global_transform
	else:
		inst.transform = get_parent().global_transform
		if spawnPoint != null:
			inst.position = spawnPoint.global_position
	get_node("/root").add_child(inst)
	


func _process(delta: float) -> void:
	cooldown_left -= delta
	if action_key == "":
		if cooldown_left < 0:
			doAbility()
	elif Input.is_action_pressed(action_key) and cooldown_left < 0:
		doAbility()
