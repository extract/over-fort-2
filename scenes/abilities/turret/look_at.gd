extends Node3D



func _process(_delta):
	func_body(_delta)

func func_body(_delta):
	var closest_player = get_closest_player()
	
	if closest_player:
		look_at(closest_player.global_position, Vector3.UP)

func get_closest_player() -> Node3D:
	var players = get_tree().get_nodes_in_group("players")
	var nearest_node: Node3D = null
	var min_distance: float = INF # Start with infinity
	
	for player in players:
		if player is Node3D:
			var distance = global_position.distance_to(player.global_position)
			if distance < min_distance:
				min_distance = distance
				nearest_node = player
				
	return nearest_node
