extends "res://scenes/abilities/turret/look_at.gd"

@export var speed: float = 10
@export var lifetime: float = 10
var is_dead: bool = false
var direction_travel: Vector3

@onready var timer: Timer = $Timer


func _ready() -> void:
	direction_travel = position - transform.basis.z


func _process(delta: float) -> void:
	func_body(delta)
	position -= direction_travel * speed * delta

	lifetime -= delta
	if lifetime < 0:
		explode()


func explode() -> void:
	if is_dead:
		return
	is_dead = true
	timer.start()


func _on_timer_timeout() -> void:
	queue_free()
