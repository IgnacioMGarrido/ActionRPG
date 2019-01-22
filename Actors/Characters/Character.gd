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

const JUMP_DURATION = 0.8
const MAX_JUMP_HEIGHT = 80 

const AIR_ACCELERATION = 1000
const AIR_DECCELERATION = 2000
const AIR_STEERING_POWER = 40

const GAP_SIZE = Vector2(128, 80)


var height = 0.0 setget set_height

#Air Related variables
var max_air_speed = 0.0
var air_speed = 0.0
var air_velocity : Vector2 = Vector2()
var air_steering : Vector2 = Vector2()

#Ground Movement Variables
var speed : float = 0.0
var max_speed : float = 0.0
var velocity : Vector2 = Vector2()


var input_direction : Vector2 = Vector2()
var last_move_direction : Vector2 = Vector2(1,0)


enum States { SPAWN, IDLE, MOVE, JUMP, BUMP, FALL }
var state = null


func _ready() -> void:
	_change_state(States.IDLE)
	$Tween.connect('tween_completed', self, '_on_Tween_tween_completed')
	
	for gap in get_tree().get_nodes_in_group('gap'):
		gap.connect('body_fell', self, '_on_Gap_body_fell')


func _change_state(new_state) -> void:
	#initialize new state
	match new_state:
		States.SPAWN:
			$Tween.interpolate_property(self, 'scale', scale, Vector2(1, 1), .4, Tween.TRANS_QUAD, Tween.EASE_IN)
			$Tween.start()
		States.IDLE:
			$AnimationPlayer.play("Idle")
		States.MOVE:
			$AnimationPlayer.play("walk")
		States.JUMP:
			air_speed = speed
			max_air_speed = max_speed
			air_velocity = velocity
			$AnimationPlayer.play('Idle')
			
			$Tween.interpolate_method(self, '_animate_jump_height', 0, 1, JUMP_DURATION, Tween.TRANS_LINEAR, Tween.EASE_IN)
			$Tween.start()
		States.BUMP:
			$AnimationPlayer.stop()
			
			$Tween.interpolate_property(self, 'position', position, position + BUMP_DISTANCE * -last_move_direction,BUMP_DURATION, Tween.TRANS_LINEAR, Tween.EASE_IN)
			$Tween.interpolate_method(self, '_animate_bump_height', 0, 1, BUMP_DURATION, Tween.TRANS_LINEAR, Tween.EASE_IN)
			$Tween.start() 
		States.FALL:
			$Tween.interpolate_property(self, 'scale', scale, Vector2(0,0), .4, Tween.TRANS_QUAD, Tween.EASE_IN)
			$Tween.start()
	state = new_state
	emit_signal('state_changed', new_state)


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
	elif state == States.JUMP:
		jump(delta)

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


func jump(delta) -> void:

	if input_direction:
		air_speed += AIR_ACCELERATION * delta
	else:
		air_speed -= AIR_DECCELERATION * delta
	air_speed = clamp(air_speed, 0, max_air_speed)
	
	var target_velocity = air_speed * input_direction.normalized()
	var steering_velocity = (target_velocity - air_velocity).normalized() * AIR_STEERING_POWER
	air_velocity += steering_velocity 
	
	move_and_slide(air_velocity)


func _on_Tween_tween_completed(object : Object, key : NodePath) -> void:
	if key == ":position":
		_change_state(States.IDLE)
	if key == ":_animate_jump_height":
		_change_state(States.IDLE)
	if key == ":scale":
		if state == States.FALL:
			position -= last_move_direction * GAP_SIZE
			_change_state(States.SPAWN)
		elif state == States.SPAWN:
			_change_state(States.IDLE)


func _animate_bump_height(progress) -> void:
	self.height = - pow(sin(progress * PI), 0.4) * MAX_BUMP_HEIGHT
	var shadow_scale = (-sin(progress* PI)) * 0.3 + 1
	$Shadow.scale = Vector2(shadow_scale, shadow_scale)


func _animate_jump_height(progress) -> void:
	self.height = - pow(sin(progress * PI), 0.7) * MAX_JUMP_HEIGHT
	var shadow_scale = (-sin(progress* PI)) * 0.5 + 1
	$Shadow.scale = Vector2(shadow_scale, shadow_scale)

func _on_Gap_body_fell(rid):
	if rid == get_rid():
		_change_state(States.FALL)

func set_height(value) -> void:
	$Pivot.position.y = value
	height = value















