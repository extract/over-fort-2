extends Node3D # Or Node2D.

var packedScene : PackedScene
@export var defaultPlayerScene : PackedScene
var players = {}
var heroPlayers = {}
var mapInstance;

func set_map(packedScene_):
	packedScene = packedScene_

func set_players(players_):
	players = players_

func create_players():
	#$MultiplayerSpawner.spawn_function = spawn_player
	for idx in players:
		var hero = spawn_player(idx)
		hero._activate_camera.rpc_id(idx)

func spawn_player(idx) -> Node:
	#var heroName = players[idx].get("hero")
	var hero = null
	#if heroName == "default":
	hero = defaultPlayerScene.instantiate()
	hero.name = "player_" + str(idx)
	hero.player_id = idx
	$Network.add_child(hero)
	
	heroPlayers[idx] = hero
	return hero

func _enter_tree():
	# Preconfigure game.
	print_debug("ready")
	mapInstance = packedScene.instantiate()
	get_node("/root/Game").add_child(mapInstance)
	
	print("_ready...")
	get_node("/root/Menu/MultiplayerSetup").player_loaded.rpc_id(1) # Tell the server that this peer has loaded.
	
@rpc("any_peer", "call_local", "reliable")
func request_authority(idx):
	if multiplayer.is_server():
		heroPlayers[idx].set_authority.rpc_id(idx, idx)

# Called only on the server.
func start_game():
	print_debug("start_game")
	var i = 0
	create_players()
	for idx in players:
		var hero = heroPlayers[idx]
		var spawnPoint = mapInstance.quick_func_thing(i).get_global_position()
		hero._set_spawn_point.rpc(spawnPoint)
		hero._set_global_position.rpc(spawnPoint)
		
		#hero._set_my_id.rpc(idx)
		
		#hero._activate_camera.rpc_id(idx)
		i += 1
	
	pass
	# All peers are ready to receive RPCs in this scene.
