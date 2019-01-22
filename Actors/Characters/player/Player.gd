extends Character 

class_name Player

signal direction_changed



func _input(event):
	if event.is_action_pressed("jump"):
		if not state in [States.IDLE, States.MOVE]:
			return
		_change_state(States.JUMP)

func _physics_process(delta) -> void:
	input_direction = Vector2()

	# 8 directions
	handle_eight_direction_input()
	
	#For the arrow visualizer
	if input_direction and input_direction != last_move_direction:
		emit_signal('direction_changed', input_direction)


func handle_eight_direction_input() -> void:
	input_direction.x = float(Input.is_action_pressed('move_right')) - float(Input.is_action_pressed('move_left'))
	input_direction.y = float(Input.is_action_pressed('move_down')) - float(Input.is_action_pressed('move_up'))
	
	max_speed = MAX_RUN_SPEED if Input.is_action_pressed('run') else MAX_WALK_SPEED