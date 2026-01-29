extends Button
class_name PontusReadyToStartButton

@onready var multiplayerSetupNode:PontusMultiplayerNode
var pressMeansHost:bool = false

func game_ready_mode()->void:
	pressMeansHost = true

@rpc("any_peer", "call_local", "reliable")
func inform_ready_state(id:int) -> void:
	print_debug("Player %s now ready" % id)
	multiplayerSetupNode.update_player_ready_status(id, true)
	
	pass
	
@rpc("authority", "call_local", "reliable")
func start_game_press() -> void:
	print_debug("Hosting game!")
	multiplayerSetupNode.start_the_game()
	pass

func _on_pressed() -> void:
	if !pressMeansHost:
		inform_ready_state.rpc(multiplayer.get_unique_id())
	else:
		start_game_press.rpc()
	pass # Replace with function body.

func _ready() -> void:
	multiplayerSetupNode = get_node("/root/Menu/MultiplayerSetup")
	
