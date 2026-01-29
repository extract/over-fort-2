extends Node
class_name PontusMultiplayerNode

@export var startMap : PackedScene
@export var playerScene : PackedScene
@export var lobbyScene : PackedScene
@export var gameScene : PackedScene
@onready var menuNode:Control = (($"../Menu") as Control)
@onready var lobbyInstance:PontusLobby
@onready var game: PontusGame
const MAX_CLIENTS:int = 8

var hasStartedPlaying:bool = false

var players:Dictionary[int, Dictionary] = {}
var player_info: Dictionary = {"name": "Name", "readyState": false, "hero": "default"}
var players_loaded:int = 0

func _ready()->void:
	var _err:int = multiplayer.peer_connected.connect(_on_player_connected)
	_err = multiplayer.peer_disconnected.connect(_on_player_disconnected)
	_err=multiplayer.connected_to_server.connect(_on_connected_to_server)
	_err=multiplayer.connection_failed.connect(_on_connection_failed)
	_err=multiplayer.server_disconnected.connect(_on_server_disconnected)


func host_game(port:int)->void:
	# 1. Create the peer
	var peer:ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	
	# 2. Initialize it as a server
	var error:int = peer.create_server(port, MAX_CLIENTS)
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

func _add_player(id:int, lobbyInstance_:PontusLobby)->void:
	#var playerInstance = playerScene.instantiate()
	#playerInstance.name = "player_" + str(id)
	#get_node("/root/Node3D/Network").add_child(playerInstance)
	players[id] = player_info.duplicate()
	print(str(lobbyInstance_.get_first_free_slot()))
	pass

# Called on the server when a new player joins
func _on_player_connected(id:int)->void:
	_add_player(id, lobbyInstance)
	print("Player connected: ", id)
	var numReadyPlayers:int = 0
	for player:Variant in players:
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
func _on_player_disconnected(id:int)->void:
	print("Player disconnected: ", id)
	var _err:bool = players.erase(id)

@rpc("authority", "call_local", "reliable")
func has_started_playing_server() -> bool:
	return hasStartedPlaying


func join_game(address: String = "127.0.0.1", port: int = 21057)->void:
	var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	var error:int = peer.create_client(address, port)
	
	if error != OK:
		print("Failed to create client: ", error)
		return
	
	multiplayer.multiplayer_peer = peer
	print("Attempting to connect to ", address, ":" , port)
	
@rpc("any_peer", "reliable")
func _register_player(new_player_info:Dictionary)->void:
	var new_player_id :int= multiplayer.get_remote_sender_id()
	players[new_player_id] = new_player_info

@rpc("authority", "call_local", "reliable")
func update_player_ready_status(id:int, newReadyState:bool)->void:
	var _err:bool=players[id].set("readyState", newReadyState)
	var numReadyPlayers :int= 0
	for player:int in players:
		if players[player].get("readyState"):
			numReadyPlayers += 1
	lobbyInstance.update_ready_players(numReadyPlayers, players.size())
	if numReadyPlayers == players.size():
		lobbyInstance.game_ready()
		
func start_the_game() -> void:
	multiplayer.multiplayer_peer.set_refuse_new_connections(true) ## TODO DIDNT WORK
	lobbyInstance.hide_ui()
	lobbyInstance.visible = false
	if multiplayer.is_server():
		load_game.rpc()
	pass

@rpc("any_peer", "call_local", "reliable")
func player_loaded()->void:
	print("hey... player loaded")
	if multiplayer.is_server():
		players_loaded += 1
		if players_loaded == players.size():
			game = get_node("/root/Game")
			game.start_game()
			players_loaded = 0

@rpc("authority", "call_local", "reliable")
func load_game()->void:
	var gameInstance: PontusGame = gameScene.instantiate()
	gameInstance.set_map(startMap)
	gameInstance.set_players(players)
	get_node("/root").add_child(gameInstance)
	get_node("/root/Lobby").queue_free()

func _on_connected_to_server()->void:
	var peer_id:int = multiplayer.get_unique_id()
	
	menuNode.visible = false
	lobbyInstance = lobbyScene.instantiate()
	get_node("/root/").add_child(lobbyInstance)
	_add_player(peer_id, lobbyInstance)
	
	print(str(lobbyInstance.get_first_free_slot()))
	update_player_ready_status(peer_id, false)
	print("Successfully connected to the server!")

func remove_multiplayer_peer()->void:
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	players.clear()

func _on_connected_ok()->void:
	pass
	#var peer_id = multiplayer.get_unique_id()
	#players[peer_id] = player_info

func _on_connected_fail()->void:
	remove_multiplayer_peer()

func _on_server_disconnected()->void:
	remove_multiplayer_peer()
	players.clear()

func _on_connection_failed()->void:
	print("Connection failed.")
