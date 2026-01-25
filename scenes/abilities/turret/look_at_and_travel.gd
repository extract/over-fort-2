extends "res://scenes/abilities/turret/look_at.gd"

@export var speed = 10
@export var lifetime = 10

@onready var timer: Timer = $Timer
var is_dead=false

var direction_travel
func _ready():
	direction_travel = position - transform.basis.z

func _process(delta: float) -> void:
	func_body(delta)
	position -= direction_travel * speed * delta
	
	lifetime -= delta
	if lifetime < 0:
		explode()
	

func explode():
	if is_dead:
		return
	is_dead=true
	timer.start()

func _on_timer_timeout() -> void:
	queue_free()
