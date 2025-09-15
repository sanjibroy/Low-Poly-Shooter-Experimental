extends Camera3D

func _process(delta):
	var player = get_tree().get_first_node_in_group("player")
	if player:
		global_position = player.global_position + Vector3(0, 10, 5)
