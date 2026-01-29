extends Node3D


func _process(delta: float) -> void:
	func_body(delta)


func func_body(_delta: float) -> void:
	var closest_player: Node3D = get_closest_player()

	if closest_player:
		look_at(closest_player.global_position, Vector3.UP)


func get_closest_player() -> Node3D:
	var players: Array[Node] = get_tree().get_nodes_in_group("players")
	var nearest_node: Node3D = null
	var min_distance: float = INF  # Start with infinity

	for p: Node in players:
		if p is Node3D:
			var player: Node3D = p
			var distance: float = global_position.distance_to(player.global_position)
			if distance < min_distance:
				min_distance = distance
				nearest_node = player

	return nearest_node
