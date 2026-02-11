class_name Projectile
extends Node3D

@export var speed: float = 10
@export var lifetime: float = 10
@export var sound: AudioStreamMP3

@onready var asp: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var root: Node = $"/root"

var hitbox: Hitbox


signal collision(hitboxes: Array[Hitbox])

func _ready() -> void:
	hitbox = find_children("", "Hitbox")[0]
	assert(hitbox)

	asp.stream = sound


func _process(delta: float) -> void:
	position -= transform.basis.z * speed * delta

	lifetime -= delta
	if lifetime < 0:
		_handle_collision()


func _handle_collision() -> void:
	
	# detach audio player node so it can play sound while we die
	remove_child(asp)
	asp.play()
	asp.finished.connect(asp.queue_free)
	
	collision.emit()
	
	queue_free()
