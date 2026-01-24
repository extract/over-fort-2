extends Node3D

@export var slots : Array[Node3D] = []
@export var slotsTaken : Array[bool] = []
var firstFreeSlot = 0

func get_first_free_slot() -> Node3D:
	var availableSlot = -1
	if len(slots) != len(slotsTaken):
		slotsTaken.resize(len(slots))
	for n in len(slots):
		if slotsTaken[n] == false:
			availableSlot = n
			print(availableSlot)
			break
	print(str(availableSlot))
	slotsTaken[availableSlot] = true
	return slots[availableSlot]
	
func remove_slot(idx) -> void:
	slotsTaken[idx] = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
