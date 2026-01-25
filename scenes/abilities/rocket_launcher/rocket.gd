extends Node3D

@export var speed = 10
@export var lifetime = 10

@onready var asp1: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var asp2: AudioStreamPlayer3D = $AudioStreamPlayer3D2
@onready var timer: Timer = $Timer
var is_dead=false

func _process(delta: float) -> void:
	position -= transform.basis.z * speed * delta
	
	lifetime -= delta
	if lifetime < 0:
		explode()
	

func explode():
	if is_dead:
		return
	is_dead=true
	var i = randi() % 2
	if i == 0:
		asp1.play()
	else:
		asp2.play()
	
	timer.start()

func _on_timer_timeout() -> void:
	queue_free()


func _on_hit_box_body_entered(body: Node3D) -> void:
	explode()
