extends Node3D # Or Node2D.
class_name PontusGame

var packedScene : PackedScene
@export var defaultPlayerScene : PackedScene
var players:Dictionary = {}
var heroPlayers:Dictionary[int, Player] = {}
var mapInstance:UpwardMap;
@onready var multiplayer_node: PontusMultiplayerNode

func set_map(packedScene_:PackedScene)->void:
	packedScene = packedScene_

func set_players(players_:Dictionary)->void:
	players = players_

func create_players()->void:
	#$MultiplayerSpawner.spawn_function = spawn_player
	for idx:int in players:
		var hero:Player = spawn_player(idx)
		hero._activate_camera.rpc_id(idx)

func spawn_player(idx:int) -> Player:
	#var heroName = players[idx].get("hero")
	var hero:Player = null
	#if heroName == "default":
	hero = defaultPlayerScene.instantiate()
	hero.name = "player_" + str(idx)
	hero.player_id = idx
	$Network.add_child(hero)
	
	heroPlayers[idx] = hero
	return hero

func _enter_tree()->void:
	# Preconfigure game.
	print_debug("ready")
	mapInstance = packedScene.instantiate()
	get_node("/root/Game").add_child(mapInstance)
	
	print("_ready...")
	multiplayer_node = get_node("/root/Menu/MultiplayerSetup")
	multiplayer_node.player_loaded.rpc_id(1) # Tell the server that this peer has loaded.
	
@rpc("any_peer", "call_local", "reliable")
func request_authority(idx:int)->void:
	if multiplayer.is_server():
		print("trying to set authority from server to idx: %s" % idx)
		heroPlayers[idx].set_authority.rpc(idx)

# Called only on the server.
func start_game()->void:
	print_debug("start_game")
	var i :int= 0
	create_players()
	for idx :int in players:
		var hero:Player = heroPlayers[idx]
		var spawnPoint:Vector3 = mapInstance.quick_func_thing(i).get_global_position()
		hero._set_spawn_point.rpc(spawnPoint)
		hero._set_global_position.rpc(spawnPoint)
		
		#hero._set_my_id.rpc(idx)
		
		#hero._activate_camera.rpc_id(idx)
		i += 1
	
	pass
	# All peers are ready to receive RPCs in this scene.
