extends Area3D

@export var speed = 18
@export var explosion_force = 10
@export var radius = 7



func _ready() -> void:
	($BlastRadius/CollisionShape3D as CollisionShape3D).shape.radius = radius

func _process(delta: float) -> void:
	position -= transform.basis.z * speed * delta



func _on_body_entered(_body: Node3D) -> void:
	$AudioStreamPlayer3D.play()
	for b in ($BlastRadius as Area3D).get_overlapping_bodies():
		var dir = (b.position - position).normalized()
		if b is RigidBody3D:
			(b as RigidBody3D).apply_impulse(dir * explosion_force)


func _on_timer_timeout() -> void:
	queue_free()
