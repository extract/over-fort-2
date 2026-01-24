extends Button

var PORT = 21057
@onready var lineEdit = $"../LineEdit"
@export var lobbyScene : PackedScene
@onready var menuNode = (($"../..") as Control)
 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)

func _on_pressed() -> void:
	var ip = lineEdit.text
	print(ip)
	if len(ip) != 0:
		join_game(ip)
	else:
		join_game()
	pass # Replace with function body.
	

func join_game(address: String = "127.0.0.1"):
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(address, PORT)
	
	if error != OK:
		print("Failed to create client: ", error)
		return
		
	multiplayer.multiplayer_peer = peer
	print("Attempting to connect to ", address, ":" , PORT)
	
func _on_connected_to_server():
	get_node("/root/").add_child(lobbyScene.instantiate())
	menuNode.visible = false
	print("Successfully connected to the server!")

func _on_connection_failed():
	print("Connection failed.")
