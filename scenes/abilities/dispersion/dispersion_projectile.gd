extends Area3D

@export var speed: float = 18
@export var explosion_force: float = 10
@export var radius: float = 7

@onready var blast_sphere: CollisionShape3D = $BlastRadius/CollisionShape3D
@onready var asp: AudioStreamPlayer3D = $AudioStreamPlayer3D


func _ready() -> void:
	(blast_sphere.shape as SphereShape3D).radius = radius


func _process(delta: float) -> void:
	position -= transform.basis.z * speed * delta


func _on_body_entered(_body: Node3D) -> void:
	asp.play()
	for b: Node3D in ($BlastRadius as Area3D).get_overlapping_bodies():
		var dir: Vector3 = (b.position - position).normalized()
		if b is RigidBody3D:
			(b as RigidBody3D).apply_impulse(dir * explosion_force)
		if b is CharacterBody3D:
			(b as CharacterBody3D).velocity += dir * explosion_force


func _on_timer_timeout() -> void:
	queue_free()
