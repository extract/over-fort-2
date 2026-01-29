class_name PontusMultiplayerNode
extends Node

const MAX_CLIENTS: int = 8

@export var start_map: PackedScene
@export var player_scene: PackedScene
@export var lobby_scene: PackedScene
@export var game_scene: PackedScene

var has_started_playing: bool = false

var players: Dictionary[int, Dictionary] = {}
var player_info: Dictionary = {"name": "Name", "readyState": false, "hero": "default"}
var players_loaded: int = 0

@onready var menu_node: Control = ($"../Menu") as Control
@onready var lobby_instance: PontusLobby
@onready var game: PontusGame


func _ready() -> void:
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)


func host_game(port: int) -> void:
	# 1. Create the peer
	var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()

	# 2. Initialize it as a server
	var error: int = peer.create_server(port, MAX_CLIENTS)
	if error != OK:
		print("Failed to host: ", error)
		return

	# 3. Assign the peer to the multiplayer API
	multiplayer.multiplayer_peer = peer
	print("Server started on port ", port)
	lobby_instance = lobby_scene.instantiate()
	get_node("/root/").add_child(lobby_instance)
	_add_player(1, lobby_instance)
	update_player_ready_status(1, false)
	lobby_instance.update_ready_players(0, 1)
	menu_node.visible = false


func _add_player(id: int, new_lobby_instance: PontusLobby) -> void:
	#var playerInstance = playerScene.instantiate()
	#playerInstance.name = "player_" + str(id)
	#get_node("/root/Node3D/Network").add_child(playerInstance)
	players[id] = player_info.duplicate()
	print(str(new_lobby_instance.get_first_free_slot()))


# Called on the server when a new player joins
func _on_player_connected(id: int) -> void:
	_add_player(id, lobby_instance)
	print("Player connected: ", id)
	var num_ready_players: int = 0
	for player: Variant in players:
		if players[player].get("readyState"):
			num_ready_players += 1
	lobby_instance.update_ready_players(num_ready_players, players.size())


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
func _on_player_disconnected(id: int) -> void:
	print("Player disconnected: ", id)
	players.erase(id)


@rpc("authority", "call_local", "reliable")
func has_started_playing_server() -> bool:
	return has_started_playing


func join_game(address: String = "127.0.0.1", port: int = 21057) -> void:
	var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	var error: int = peer.create_client(address, port)

	if error != OK:
		print("Failed to create client: ", error)
		return

	multiplayer.multiplayer_peer = peer
	print("Attempting to connect to ", address, ":", port)


@rpc("any_peer", "reliable")
func _register_player(new_player_info: Dictionary) -> void:
	var new_player_id: int = multiplayer.get_remote_sender_id()
	players[new_player_id] = new_player_info


@rpc("authority", "call_local", "reliable")
func update_player_ready_status(id: int, new_ready_state: bool) -> void:
	players[id].set("readyState", new_ready_state)
	var num_ready_players: int = 0
	for player: int in players:
		if players[player].get("readyState"):
			num_ready_players += 1
	lobby_instance.update_ready_players(num_ready_players, players.size())
	if num_ready_players == players.size():
		lobby_instance.game_ready()


func start_the_game() -> void:
	multiplayer.multiplayer_peer.set_refuse_new_connections(true)  ## TODO DIDNT WORK
	lobby_instance.hide_ui()
	lobby_instance.visible = false
	if multiplayer.is_server():
		load_game.rpc()


@rpc("any_peer", "call_local", "reliable")
func player_loaded() -> void:
	print("hey... player loaded")
	if multiplayer.is_server():
		players_loaded += 1
		if players_loaded == players.size():
			game = get_node("/root/Game")
			game.start_game()
			players_loaded = 0


@rpc("authority", "call_local", "reliable")
func load_game() -> void:
	var game_instance: PontusGame = game_scene.instantiate()
	game_instance.set_map(start_map)
	game_instance.set_players(players)
	get_node("/root").add_child(game_instance)
	get_node("/root/Lobby").queue_free()


func _on_connected_to_server() -> void:
	var peer_id: int = multiplayer.get_unique_id()

	menu_node.visible = false
	lobby_instance = lobby_scene.instantiate()
	get_node("/root/").add_child(lobby_instance)
	_add_player(peer_id, lobby_instance)

	print(str(lobby_instance.get_first_free_slot()))
	update_player_ready_status(peer_id, false)
	print("Successfully connected to the server!")


func remove_multiplayer_peer() -> void:
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	players.clear()


func _on_connected_ok() -> void:
	pass
	#var peer_id = multiplayer.get_unique_id()
	#players[peer_id] = player_info


func _on_connected_fail() -> void:
	remove_multiplayer_peer()


func _on_server_disconnected() -> void:
	remove_multiplayer_peer()
	players.clear()


func _on_connection_failed() -> void:
	print("Connection failed.")
