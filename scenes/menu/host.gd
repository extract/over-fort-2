extends Button
var port: int = 21057

@onready var multiplayer_setup_node: PontusMultiplayerNode = $"../../../MultiplayerSetup"

#var peers : Map = []

@onready var menu_node: Control = ($"../..") as Control


func _on_pressed() -> void:
	print("Hello $PORT", port)
	multiplayer_setup_node.host_game(port)
