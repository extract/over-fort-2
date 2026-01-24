extends Area3D

@export var speed = 18
@export var explosion_force = 10


func _process(delta: float) -> void:
	position -= transform.basis.z * speed * delta



func _on_body_entered(_body: Node3D) -> void:
	for b in ($BlastRadius as Area3D).get_overlapping_bodies():
		var dir = (b.position - position).normalized()
		if b is RigidBody3D:
			(b as RigidBody3D).apply_impulse(dir * explosion_force)
	queue_free()
