extends Node3D
class_name PontusLobby

@export var slots : Array[Node3D] = []
@export var slotsTaken : Array[bool] = []
@export var button : Node

@onready var waiting_label: Label = $"LobbyUi/Control/WaitingLabel"
@onready var number_ready_label: Label = $"LobbyUi/Control/NumberReady"
@onready var ready_to_start_button: PontusReadyToStartButton = $"LobbyUi/Control/ReadyStartButton"
@onready var lobby_ui: Control = $"LobbyUi"

func get_first_free_slot() -> int:
	var availableSlot:int = -1
	if len(slots) != len(slotsTaken):
		var _err:int = slotsTaken.resize(len(slots))
	for n:int in len(slots):
		if slotsTaken[n] == false:
			availableSlot = n
			break
	return availableSlot

func set_first_free_slot() -> Node3D:
	var availableSlot:int = get_first_free_slot()
	print(str(availableSlot))
	slotsTaken[availableSlot] = true
	return slots[availableSlot]
	
func remove_slot(idx:int) -> void:
	slotsTaken[idx] = false

#@rpc("authority")
func update_ready_players(readyCount:int, numPlayers:int) -> void:
	number_ready_label.text = "(" + str(readyCount) + "/" + str(numPlayers) + ") ready"
	
func game_ready() -> void:
	waiting_label.text = "... Waiting for host to start game"
	number_ready_label.text = "Ready"
	if multiplayer.is_server():
		ready_to_start_button.text = "Start Game!"
		ready_to_start_button.game_ready_mode()
	else:
		ready_to_start_button.visible = false

func hide_ui() -> void:
	lobby_ui.visible = false
	
func player_ready() -> void:
	var _err:Node3D =set_first_free_slot()
	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
