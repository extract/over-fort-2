extends Node

@export var startMap : PackedScene
@export var playerScene : PackedScene
@export var lobbyScene : PackedScene
@export var gameScene : PackedScene
@onready var networkNode = $"../Network"
@onready var menuNode = (($"../Menu") as Control)
@onready var lobbyInstance
const MAX_CLIENTS = 8

var hasStartedPlaying = false

var players = {}
var player_info = {"name": "Name", "readyState": false, "hero": "default"}
var players_loaded = 0

func _ready():
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)


func host_game(port):
	# 1. Create the peer
	var peer = ENetMultiplayerPeer.new()
	
	# 2. Initialize it as a server
	var error = peer.create_server(port, MAX_CLIENTS)
	if error != OK:
		print("Failed to host: ", error)
		return
	
	# 3. Assign the peer to the multiplayer API
	multiplayer.multiplayer_peer = peer
	print("Server started on port ", port)
	lobbyInstance = lobbyScene.instantiate()
	get_node("/root/").add_child(lobbyInstance)
	_add_player(1, lobbyInstance)
	update_player_ready_status(1, false)
	lobbyInstance.update_ready_players(0, 1)
	menuNode.visible = false

func _add_player(id, lobbyInstance_):
	#var playerInstance = playerScene.instantiate()
	#playerInstance.name = "player_" + str(id)
	#get_node("/root/Node3D/Network").add_child(playerInstance)
	players[id] = player_info.duplicate()
	print(str(lobbyInstance_.get_first_free_slot()))
	pass

# Called on the server when a new player joins
func _on_player_connected(id):
	_add_player(id, lobbyInstance)
	print("Player connected: ", id)
	var numReadyPlayers = 0
	for player in players:
		if players[player].get("readyState"):
			numReadyPlayers += 1
	lobbyInstance.update_ready_players(numReadyPlayers, players.size())
	
#	if len(multiplayer.get_peers()) + 1 >= 3 and !hasStartedPlaying:
#		hasStartedPlaying = true
#		
#		var lobbyNode = get_node("/root/Lobby")
#		var mapInstance = startMap.instantiate()
#		_add_player(id)
#		get_node("/root").remove_child(lobbyNode)
#		get_node("/root/Node3D/Network").add_child(mapInstance)
		
		#lobbyInstance.visible = false

# Called on the server when a player leaves
func _on_player_disconnected(id):
	print("Player disconnected: ", id)
	players.erase(id)

@rpc("authority", "call_local", "reliable")
func has_started_playing_server() -> bool:
	return hasStartedPlaying


func join_game(address: String = "127.0.0.1", port: int = 21057):
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(address, port)
	
	if error != OK:
		print("Failed to create client: ", error)
		return
	
	multiplayer.multiplayer_peer = peer
	print("Attempting to connect to ", address, ":" , port)
	
@rpc("any_peer", "reliable")
func _register_player(new_player_info):
	var new_player_id = multiplayer.get_remote_sender_id()
	players[new_player_id] = new_player_info

@rpc("authority", "call_local", "reliable")
func update_player_ready_status(id, newReadyState):
	players[id].set("readyState", newReadyState)
	var numReadyPlayers = 0
	for player in players:
		if players[player].get("readyState"):
			numReadyPlayers += 1
	lobbyInstance.update_ready_players(numReadyPlayers, players.size())
	if numReadyPlayers == players.size():
		lobbyInstance.game_ready()
		
func start_the_game() -> void:
	multiplayer.multiplayer_peer.set_refuse_new_connections(true) ## TODO DIDNT WORK
	lobbyInstance.hide_ui()
	lobbyInstance.visible = false
	load_game.rpc("res://scenes/game/Game.tscn")
	pass

@rpc("any_peer", "call_local", "reliable")
func player_loaded():
	print("hey... player loaded")
	if multiplayer.is_server():
		players_loaded += 1
		if players_loaded == players.size():
			$/root/Game.start_game()
			players_loaded = 0

@rpc("call_local", "reliable")
func load_game(game_scene_path):
	var gameInstance = gameScene.instantiate()
	gameInstance.set_map(startMap)
	gameInstance.set_players(players)
	get_node("/root").add_child(gameInstance)
	get_node("/root/Lobby").queue_free()

func _on_connected_to_server():
	var peer_id = multiplayer.get_unique_id()
	
	menuNode.visible = false
	lobbyInstance = lobbyScene.instantiate()
	get_node("/root/").add_child(lobbyInstance)
	_add_player(peer_id, lobbyInstance)
	
	print(str(lobbyInstance.get_first_free_slot()))
	update_player_ready_status(peer_id, false)
	print("Successfully connected to the server!")

func remove_multiplayer_peer():
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	players.clear()

func _on_connected_ok():
	pass
	#var peer_id = multiplayer.get_unique_id()
	#players[peer_id] = player_info

func _on_connected_fail():
	remove_multiplayer_peer()

func _on_server_disconnected():
	remove_multiplayer_peer()
	players.clear()

func _on_connection_failed():
	print("Connection failed.")
