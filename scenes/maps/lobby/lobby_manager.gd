class_name PontusLobby
extends Node3D

@export var slots: Array[Node3D] = []
@export var slots_taken: Array[bool] = []
@export var button: Node

@onready var waiting_label: Label = $"LobbyUi/Control/WaitingLabel"
@onready var number_ready_label: Label = $"LobbyUi/Control/NumberReady"
@onready var ready_to_start_button: PontusReadyToStartButton = $"LobbyUi/Control/ReadyStartButton"
@onready var lobby_ui: Control = $"LobbyUi"


func get_first_free_slot() -> int:
	var available_slot: int = -1
	if len(slots) != len(slots_taken):
		slots_taken.resize(len(slots))
	for n: int in len(slots):
		if slots_taken[n] == false:
			available_slot = n
			break
	return available_slot


func set_first_free_slot() -> Node3D:
	var available_slot: int = get_first_free_slot()
	print(str(available_slot))
	slots_taken[available_slot] = true
	return slots[available_slot]


func remove_slot(idx: int) -> void:
	slots_taken[idx] = false


#@rpc("authority")
func update_ready_players(ready_count: int, num_players: int) -> void:
	number_ready_label.text = "(" + str(ready_count) + "/" + str(num_players) + ") ready"


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
	set_first_free_slot()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.
