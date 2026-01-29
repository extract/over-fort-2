extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var count: int = len(multiplayer.get_peers()) + 1
	text = "(" + str(count) + "/3) connected"
