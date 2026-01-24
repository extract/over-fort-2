extends Node3D

@export var max_fly_time = 5
var remaining_fly_time = max_fly_time
@export var fly_power = 0.15

@export var action_key = "jump"

@onready var cb: CharacterBody3D = $".."

func _physics_process(delta: float) -> void:
	
	if cb.is_on_floor():
		remaining_fly_time += delta
		clamp(remaining_fly_time,0,max_fly_time)
	
	if Input.is_action_pressed("jump") and remaining_fly_time > 0:
		cb.velocity.y += fly_power
		remaining_fly_time -= delta
		
		
