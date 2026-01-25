extends Node3D


@export var action_key = ""
@export var rocket: PackedScene
@export var cooldown = 1.0
@export var spawnPoint : Node3D
var cooldown_left=0

@onready var asp: AudioStreamPlayer3D = $AudioStreamPlayer3D

@rpc("any_peer", "call_local", "reliable")
func doAbility():
	asp.play()
	
	cooldown_left = cooldown
	var inst: Node3D = rocket.instantiate()
	
	inst.transform = get_parent_node_3d().global_transform
	if spawnPoint != null:
		inst.transform = spawnPoint.global_transform
	get_node("/root").add_child(inst)
	


func _process(delta: float) -> void:
	if !is_multiplayer_authority():
		return
		
	cooldown_left -= delta
	if action_key == "":
		if cooldown_left < 0:
			doAbility.rpc()
	elif Input.is_action_pressed(action_key) and cooldown_left < 0:
		doAbility.rpc()
