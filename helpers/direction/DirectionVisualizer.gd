extends Position2D

export(Vector2) var scale_range = Vector2(0.5, 1.0)
var max_speed : float= 0.0
var last_player_speed : float = 0



func _ready() -> void:
	var player_node = $".."
	$"../States/Move".connect('direction_changed', self, '_on_Player_direction_changed')
	$"../States/Idle".connect('direction_changed', self, '_on_Player_direction_changed')

	set_process(false)


func _on_Player_direction_changed(direction : Vector2) -> void:
	rotation = direction.angle()
	if direction == Vector2(0,-1):
		visible = false
	else:
		visible = true
