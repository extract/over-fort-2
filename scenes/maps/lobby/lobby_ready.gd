class_name PontusReadyToStartButton
extends Button
var press_means_host: bool = false

@onready var multiplayer_setup_node: PontusMultiplayerNode


func game_ready_mode() -> void:
	press_means_host = true


@rpc("any_peer", "call_local", "reliable")
func inform_ready_state(id: int) -> void:
	print_debug("Player %s now ready" % id)
	multiplayer_setup_node.update_player_ready_status(id, true)


@rpc("authority", "call_local", "reliable")
func start_game_press() -> void:
	print_debug("Hosting game!")
	multiplayer_setup_node.start_the_game()


func _on_pressed() -> void:
	if !press_means_host:
		inform_ready_state.rpc(multiplayer.get_unique_id())
	else:
		start_game_press.rpc()


func _ready() -> void:
	multiplayer_setup_node = get_node("/root/Menu/MultiplayerSetup")
