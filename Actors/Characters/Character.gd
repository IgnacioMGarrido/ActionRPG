 extends KinematicBody2D

class_name Character

#For visualization
signal speed_updated
signal state_changed


var input_direction : Vector2 = Vector2()
var last_move_direction : Vector2 = Vector2(1,0)


const MAX_WALK_SPEED = 400
const MAX_RUN_SPEED = 700

var speed : float = 0.0
var max_speed : float = 0.0

var velocity : Vector2 = Vector2()

func _physics_process(delta) -> void:
	if input_direction:
		last_move_direction = input_direction
		if speed != max_speed:
			speed = max_speed
	else:
		speed = 0.0
	emit_signal('speed_updated', speed)
	
	velocity = input_direction.normalized() * speed;
	move_and_slide(velocity)

#	var motion = input_direction.normalized() * speed * delta
#	move_and_collide(motion)