extends Node

# This creates a slot in the Inspector window
@export var health_component: HealthComponent


func _ready() -> void:
	if health_component:
		health_component.died.connect(_on_died)
	else:
		push_error("HealthComponent not assigned to " + owner.name)


func _on_died() -> void:
	queue_free()
