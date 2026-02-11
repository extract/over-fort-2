extends Ability

@export var action_key: String = "e"
@export var projectile: PackedScene



func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(action_key):
		do_action()

func _on_action() -> void:
	var inst: Node3D = projectile.instantiate()
	inst.transform = (%Crosshair as Node3D).global_transform
	get_node("/root").add_child(inst)
