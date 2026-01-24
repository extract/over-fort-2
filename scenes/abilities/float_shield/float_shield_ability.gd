extends Node3D


@export var action_key = "right_mouse"
@export var float_shield: PackedScene
var inst: Node3D

@export var cooldown = 2
var cooldown_left = 0
var is_shield_active = false
@export var shield_speed = 1

func doAction():
	cooldown_left = cooldown
	
	if is_shield_active:
		inst.queue_free()
		is_shield_active = false
	else:
		inst = float_shield.instantiate()
		#inst.rotation = global_rotation
		inst.transform = inst.transform.looking_at(-(%Camera3D as Camera3D).global_transform.basis.z)
		inst.position = global_position

		get_node("/root").add_child(inst)
		is_shield_active = true
	

func _process(delta: float) -> void:
	cooldown_left -= delta
	
	if Input.is_action_just_pressed(action_key) and cooldown_left < 0:
		doAction()
	
	if is_shield_active and Input.is_action_pressed(action_key):
			inst.position -= inst.transform.basis.z * shield_speed * delta
