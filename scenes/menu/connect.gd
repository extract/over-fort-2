extends Button

var port: int = 21057
@onready var line_edit: LineEdit = $"../LineEdit"
@onready var multiplayer_setup_node: PontusMultiplayerNode = $"../../../MultiplayerSetup"


func _on_pressed() -> void:
	var user_input: String = line_edit.text
	var ip: String = "127.0.0.1"
	if len(user_input) > 0:
		if text.find(":") != -1:
			ip = user_input.split(":")[0]
			port = user_input.split(":")[1] as int
		else:
			ip = user_input
	print(ip, port)
	multiplayer_setup_node.join_game(ip, port)
