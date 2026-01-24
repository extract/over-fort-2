extends Button
@export var startMap : PackedScene
@export var playerScene : PackedScene
@export var lobbyScene : PackedScene
@onready var networkNode = $"../../../Network"


var PORT = 21057
const MAX_CLIENTS = 8
@onready var menuNode = (($"../..") as Control)

func _on_pressed() -> void:
	print("Hello $PORT", PORT)
	host_game()
	pass # Replace with function body.

func _ready():
	# It's a good practice to connect signals before starting the server
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)

func host_game():
	# 1. Create the peer
	var peer = ENetMultiplayerPeer.new()
	
	# 2. Initialize it as a server
	var error = peer.create_server(PORT, MAX_CLIENTS)
	if error != OK:
		print("Failed to host: ", error)
		return
		
	# 3. Assign the peer to the multiplayer API
	multiplayer.multiplayer_peer = peer
	print("Server started on port ", PORT)
	get_node("/root/").add_child(lobbyScene.instantiate())
	menuNode.visible = false
	
	

# Called on the server when a new player joins
func _on_player_connected(id):
	
	print("Player connected: ", id)
	print("Players: " + str(len(multiplayer.get_peers()) + 1) + "/3")
	
	if len(multiplayer.get_peers()) + 1 >= 3:
		print("aa")

# Called on the server when a player leaves
func _on_player_disconnected(id):
	print("Player disconnected: ", id)
