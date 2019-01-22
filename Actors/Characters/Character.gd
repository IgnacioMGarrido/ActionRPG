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


enum STATES { IDLE, MOVE }
var state = null


func _ready() -> void:
	_change_state(STATES.IDLE)
	


func _change_state(new_state) -> void:
	emit_signal('state_changed', new_state)
	
	match new_state:
		STATES.IDLE:
			$AnimationPlayer.play("Idle")
		STATES.MOVE:
			$AnimationPlayer.play("walk")
	
	state = new_state


func _physics_process(delta) -> void:

	update_direction()
	
	if state == STATES.IDLE and input_direction:
		_change_state(STATES.MOVE)
	elif state == STATES.MOVE:
		move()
		if not input_direction:
			_change_state(STATES.IDLE)


func update_direction() -> void:
	if input_direction:
		last_move_direction = input_direction


func move() -> void:
	if input_direction:
		if speed != max_speed:
			speed = max_speed
	else:
		speed = 0.0
 
		
	emit_signal('speed_updated', speed)
	
	velocity = input_direction.normalized() * speed;
	move_and_slide(velocity)













