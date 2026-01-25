extends CharacterBody3D


@export var speed = 5.0
@export var jump_velocity = 4.5

@export var mouse_sensitivity = 0.01
@export var team = 1

@export var player_id := 1:
	set(id):
		player_id = id
		set_multiplayer_authority(id)

var spawn_point : Vector3

@rpc("authority", "call_local", "reliable")
func _set_global_position(newGlobalPos):
	global_transform.origin = newGlobalPos
	
@rpc("authority", "call_local", "reliable")
func _set_spawn_point(newGlobalPos):
	spawn_point = newGlobalPos
	
@rpc("authority", "call_local", "reliable")
func _activate_camera():
	$Camera3D.make_current()

@rpc("authority", "call_local", "reliable")
func set_authority(player_id_):
	player_id = player_id_
	set_multiplayer_authority(player_id_)
	$MultiplayerSynchronizer.set_multiplayer_authority(player_id_)

@export var health_component: HealthComponent 

func get_health() -> float:
	if health_component == null:
		return 0
	return health_component.current_health

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)

	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
var authority_set : bool = false 

func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority() and multiplayer.is_server() and !authority_set:
		get_node("/root/Game").request_authority(player_id)
		print("spam me baby")
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
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
