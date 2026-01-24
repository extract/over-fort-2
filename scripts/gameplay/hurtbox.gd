extends Area3D
class_name Hurtbox

# Link this to the HealthComponent in the inspector
@export var health_component: HealthComponent

func handle_hit(damage: float):
	if health_component:
		health_component.take_damage(damage)
