extends KinematicBody2D

class_name Character

var input_direction : Vector2 = Vector2()
var last_move_direction : Vector2 = Vector2(1,0)

func _physics_process(delta) -> void:
	if input_direction:
		last_move_direction = input_direction