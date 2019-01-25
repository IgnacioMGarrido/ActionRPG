extends State

class_name Motion

signal direction_changed

export(float) var MAX_WALK_SPEED = 450
export(float) var MAX_RUN_SPEED = 700


var speed = 0.0
var max_speed = 0.0
var velocity = Vector2()

onready var inputHandler : InputHandler = $"../../InputHandler"
var last_move_direction : Vector2 = Vector2(1,0)

func handle_input(host,event):
	if inputHandler.is_damaged():
		print("aaa")
		emit_signal("finished", "stagger")
		

func get_input_direction():
	var input_direction = inputHandler.get_input_direction()
	last_move_direction = input_direction
	emit_signal('direction_changed', input_direction)
	return input_direction


func update_look_direction(host, direction):
	if direction and host.look_direction != direction:
		host.look_direction = direction
	if not direction.x in [-1, 1]:
		return
	host.get_node('Pivot').set_scale(Vector2(direction.x, 1))

func get_current_speed():
	return MAX_RUN_SPEED if Input.is_action_pressed("run") else MAX_WALK_SPEED