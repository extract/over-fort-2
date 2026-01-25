extends Node3D

@export var slots : Array[Node3D] = []
@export var slotsTaken : Array[bool] = []
@export var button : Node

func get_first_free_slot() -> int:
	var availableSlot = -1
	if len(slots) != len(slotsTaken):
		slotsTaken.resize(len(slots))
	for n in len(slots):
		if slotsTaken[n] == false:
			availableSlot = n
			break
	return availableSlot

func set_first_free_slot() -> Node3D:
	var availableSlot = get_first_free_slot()
	print(str(availableSlot))
	slotsTaken[availableSlot] = true
	return slots[availableSlot]
	
func remove_slot(idx) -> void:
	slotsTaken[idx] = false

#@rpc("authority")
func update_ready_players(readyCount, numPlayers) -> void:
	get_node("LobbyUi/Control/NumberReady").text = "(" + str(readyCount) + "/" + str(numPlayers) + ") ready"
	
func game_ready() -> void:
	get_node("LobbyUi/Control/WaitingLabel").text = "... Waiting for host to start game"
	get_node("LobbyUi/Control/NumberReady").text = "Ready"
	if multiplayer.is_server():
		get_node("LobbyUi/Control/ReadyStartButton").text = "Start Game!"
		get_node("LobbyUi/Control/ReadyStartButton").game_ready_mode()
	else:
		get_node("LobbyUi/Control/ReadyStartButton").visible = false

func hide_ui() -> void:
	get_node("LobbyUi").visible = false
	
func player_ready(idx) -> void:
	set_first_free_slot()
	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
