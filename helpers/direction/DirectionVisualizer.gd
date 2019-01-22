extends Position2D

func _ready() -> void:
	var player_node = $".."
	player_node.connect('direction_changed', self, '_on_player_direction_changed')


func _on_player_direction_changed(direction : Vector2) -> void:
	rotation = direction.angle()
	if direction == Vector2(0,-1):
		visible = false
	else:
		visible = true