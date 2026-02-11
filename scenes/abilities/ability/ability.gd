class_name Ability
extends Node3D

@export var cooldown: float = 2
@export var sound: AudioStreamMP3

var remaining_cooldown: float = 0

@onready var asp: AudioStreamPlayer3D = $AudioStreamPlayer3D

signal action


@rpc("any_peer", "call_local", "reliable")
func do_action() -> void:
	
	if remaining_cooldown < 0 or cooldown == 0:
		
		action.emit()
		asp.play()
		remaining_cooldown = cooldown


func _process(delta: float) -> void:
	
	if !is_multiplayer_authority():
		return
		
	if remaining_cooldown > 0:
		remaining_cooldown -= delta
