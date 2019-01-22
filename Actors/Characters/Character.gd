extends KinematicBody2D

class_name Character

#For visualization
signal speed_updated
signal state_changed


const MAX_WALK_SPEED = 400
const MAX_RUN_SPEED = 700

const BUMP_DURATION = 0.2
const BUMP_DISTANCE = 60
const MAX_BUMP_HEIGHT = 50

var height = 0.0 setget set_height

var speed : float = 0.0
var max_speed : float = 0.0


var input_direction : Vector2 = Vector2()
var last_move_direction : Vector2 = Vector2(1,0)


var velocity : Vector2 = Vector2()


enum States { IDLE, MOVE, BUMP }
var state = null


func _ready() -> void:
	_change_state(States.IDLE)
	$Tween.connect('tween_completed', self, '_on_Tween_tween_completed')


func _change_state(new_state) -> void:
	emit_signal('state_changed', new_state)
	
	match new_state:
		States.IDLE:
			$AnimationPlayer.play("Idle")
		States.MOVE:
			$AnimationPlayer.play("walk")
		States.BUMP:
			$AnimationPlayer.stop()
			
			$Tween.interpolate_property(self, 'position', position, position + BUMP_DISTANCE * -last_move_direction,BUMP_DURATION, Tween.TRANS_LINEAR, Tween.EASE_IN)
			$Tween.interpolate_method(self, '_animate_bump_height', 0, 1, BUMP_DURATION, Tween.TRANS_LINEAR, Tween.EASE_IN)
			$Tween.start() 
	
	state = new_state


func _physics_process(delta) -> void:

	update_direction()
	
	if state == States.IDLE and input_direction:
		_change_state(States.MOVE)
	elif state == States.MOVE:
		if not input_direction:
			_change_state(States.IDLE)
		
		var collision_info : KinematicCollision2D = move(delta)
		if collision_info:
			var collider : Object = collision_info.collider
			if max_speed == MAX_RUN_SPEED and collider.is_in_group('environment'):
				_change_state(States.BUMP)


func update_direction() -> void:
	if input_direction:
		last_move_direction = input_direction


func move(delta) -> KinematicCollision2D:
	if input_direction:
		if speed != max_speed:
			speed = max_speed
	else:
		speed = 0.0
	emit_signal('speed_updated', speed)
	
	velocity = input_direction.normalized() * speed;
	move_and_slide(velocity, Vector2(), 5, 2)
	
	var slide_count : int = get_slide_count()
	return get_slide_collision(slide_count - 1) if slide_count else null


func _on_Tween_tween_completed(object : Object, key : NodePath) -> void:
	if key == ":_animate_bump_height":
		_change_state(States.IDLE)


func _animate_bump_height(progress) -> void:
	self.height = - pow(sin(progress * PI), 0.5) * MAX_BUMP_HEIGHT


func set_height(value) -> void:
	$Pivot.position.y = value
	height = value















