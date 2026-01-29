extends Node3D

@export var action_key: String = ""
@export var rocket: PackedScene
@export var cooldown: float = 1.0
@export var spawn_point: Node3D
var cooldown_left: float = 0

@onready var asp: AudioStreamPlayer3D = $AudioStreamPlayer3D

@rpc("any_peer", "call_local", "reliable")
func do_ability() -> void:
	asp.play()

	cooldown_left = cooldown
	var inst: Node3D = rocket.instantiate()

	inst.transform = get_parent_node_3d().global_transform
	if spawn_point != null:
		inst.transform = spawn_point.global_transform
	get_node("/root").add_child(inst)


func _process(delta: float) -> void:
	if !is_multiplayer_authority():
		return

	cooldown_left -= delta
	if action_key == "":
		if cooldown_left < 0:
			do_ability.rpc()
	elif Input.is_action_pressed(action_key) and cooldown_left < 0:
		do_ability.rpc()
