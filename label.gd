extends Label

@export var player: NodePath

func _process(delta: float) -> void:
	var player_node = get_node_or_null(player)
	if player_node:
		var player_height = round(player_node.global_transform.origin.y)
		text = "Hauteur: %d m" % player_height
	else:
		print("Player node not found!")
