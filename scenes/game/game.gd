class_name PontusGame
extends Node3D

@export var default_player_scene: PackedScene

var packed_scene: PackedScene
var players: Dictionary = {}
var hero_players: Dictionary[int, Player] = {}
var map_instance: UpwardMap

@onready var multiplayer_node: PontusMultiplayerNode


func set_map(new_packed_scene: PackedScene) -> void:
	packed_scene = new_packed_scene


func set_players(new_players: Dictionary) -> void:
	players = new_players


func create_players() -> void:
	#$MultiplayerSpawner.spawn_function = spawn_player
	for idx: int in players:
		var hero: Player = spawn_player(idx)
		hero._activate_camera.rpc_id(idx)


func spawn_player(idx: int) -> Player:
	#var heroName = players[idx].get("hero")
	var hero: Player = null
	#if heroName == "default":
	hero = default_player_scene.instantiate()
	hero.name = "player_" + str(idx)
	hero.player_id = idx
	$Network.add_child(hero)

	hero_players[idx] = hero
	return hero


func _enter_tree() -> void:
	# Preconfigure game.
	print_debug("ready")
	map_instance = packed_scene.instantiate()
	get_node("/root/Game").add_child(map_instance)

	print("_ready...")
	multiplayer_node = get_node("/root/Menu/MultiplayerSetup")
	multiplayer_node.player_loaded.rpc_id(1)  # Tell the server that this peer has loaded.


@rpc("any_peer", "call_local", "reliable")
func request_authority(idx: int) -> void:
	if multiplayer.is_server():
		print("trying to set authority from server to idx: %s" % idx)
		hero_players[idx].set_authority.rpc(idx)


# Called only on the server.
func start_game() -> void:
	print_debug("start_game")
	var i: int = 0
	create_players()
	for idx: int in players:
		var hero: Player = hero_players[idx]
		var spawn_point: Vector3 = map_instance.quick_func_thing(i).get_global_position()
		hero._set_spawn_point.rpc(spawn_point)
		hero._set_global_position.rpc(spawn_point)

		#hero._set_my_id.rpc(idx)

		#hero._activate_camera.rpc_id(idx)
		i += 1

	# All peers are ready to receive RPCs in this scene.
