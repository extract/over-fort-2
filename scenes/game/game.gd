extends Node3D # Or Node2D.

var packedScene : PackedScene
@export var defaultPlayerScene : PackedScene
var players = {}
var heroPlayers = {}

func set_map(packedScene_):
	packedScene = packedScene_

func set_players(players_):
	players = players_

func _ready():
	# Preconfigure game.
	print_debug("ready")
	var mapInstance = packedScene.instantiate()
	get_node("/root/Game").add_child(mapInstance)
	get_node("/root/Menu/MultiplayerSetup").player_loaded.rpc_id(1) # Tell the server that this peer has loaded.
	
	mapInstance.consume_next_spawn_point()
	for idx in players:
		var heroName = players[idx].get("hero")
		var hero = null
		if heroName == "default":
			hero = defaultPlayerScene.instantiate()
		heroPlayers.set(players[idx], hero)
	#for idx in heroPlayers:
		#heroPlayers.get(idx).global_transform.origin = mapInstance.consume_next_spawn_point().get_global_position()
	

# Called only on the server.
func start_game():
	print_debug("start_game")
	pass
	# All peers are ready to receive RPCs in this scene.
