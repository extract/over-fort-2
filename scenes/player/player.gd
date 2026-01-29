class_name Player
extends CharacterBody3D

@export var speed: float = 5.0
@export var jump_velocity: float = 4.5
@export var health_component: HealthComponent

@export var mouse_sensitivity: float = 0.01
@export var team: int = 1

@export var player_id: int = 1:
	set(id):
		player_id = id
		set_multiplayer_authority(id)

var spawn_point: Vector3
var authority_set: bool = false

@onready var camera: Camera3D = $Camera3D
@onready var game: PontusGame = $"/root/Game"

@rpc("authority", "call_local", "reliable")
func _set_global_position(new_global_pos: Vector3) -> void:
	global_transform.origin = new_global_pos


@rpc("authority", "call_local", "reliable")
func _set_spawn_point(new_global_pos: Vector3) -> void:
	spawn_point = new_global_pos


@rpc("authority", "call_local", "reliable")
func _activate_camera() -> void:
	camera.make_current()


@rpc("authority", "call_local", "reliable")
func set_authority(new_player_id: int) -> void:
	print("set authority from server to idx: ", new_player_id, " on ", multiplayer.get_unique_id())
	player_id = new_player_id
	set_multiplayer_authority(new_player_id)
	$MultiplayerSynchronizer.set_multiplayer_authority(new_player_id)


func get_health() -> float:
	if health_component == null:
		return 0
	return health_component.current_health


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_event: InputEventMouseMotion = event
		rotate_y(-mouse_event.relative.x * mouse_sensitivity)

	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()


func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority() and multiplayer.is_server() and !authority_set:
		game.request_authority(player_id)
		authority_set = true
		return
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir: Vector2 = Input.get_vector("left", "right", "forward", "backward")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
