extends Button

@onready var multiplayerSetupNode:PontusMultiplayerNode = $"../../../MultiplayerSetup"

#var peers : Map = []

var PORT:int = 21057

@onready var menuNode: Control = (($"../..") as Control)


func _on_pressed() -> void:
	print("Hello $PORT", PORT)
	multiplayerSetupNode.host_game(PORT)
	pass # Replace with function body.
