extends Button

@onready var multiplayerSetupNode = $"../../../MultiplayerSetup"

#var peers : Map = []

var PORT = 21057

@onready var menuNode = (($"../..") as Control)


func _on_pressed() -> void:
	print("Hello $PORT", PORT)
	multiplayerSetupNode.host_game(PORT)
	pass # Replace with function body.

func _ready():
	pass
	
