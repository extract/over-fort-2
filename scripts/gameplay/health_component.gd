# health_component.gd
extends Node
class_name HealthComponent

signal health_changed(new_health: float)
signal died

@export var max_health: float = 100.0
@onready var current_health: float = max_health

func take_damage(amount: float):
	current_health = clamp(current_health - amount, 0, max_health)
	health_changed.emit(current_health)
	
	if current_health <= 0:
		died.emit()

func heal(amount: float):
	current_health = clamp(current_health + amount, 0, max_health)
	health_changed.emit(current_health)
