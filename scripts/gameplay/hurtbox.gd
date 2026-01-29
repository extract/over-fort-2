class_name Hurtbox
extends Area3D

# Link this to the HealthComponent in the inspector
@export var health_component: HealthComponent


func handle_hit(damage: float) -> void:
	if health_component:
		health_component.take_damage(damage)
