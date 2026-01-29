extends Node3D

@export var action_key: String = "e"
@export var projectile: PackedScene
@export var cooldown: float = 2
var remaining_cooldown: float = 0

@onready var asp: AudioStreamPlayer3D = $AudioStreamPlayer3D

@rpc("any_peer", "call_local", "reliable")
func do_action() -> void:
	asp.play()
	remaining_cooldown = cooldown
	var inst: Node3D = projectile.instantiate()
	inst.transform = (%Crosshair as Node3D).global_transform
	get_node("/root").add_child(inst)


func _process(delta: float) -> void:
	if !is_multiplayer_authority():
		return
	remaining_cooldown -= delta

	if Input.is_action_just_pressed("e") and remaining_cooldown < 0:
		do_action.rpc()
