extends Motion

export(float) var BASE_MAX_AIR_SPEED = 400.0

export(float) var AIR_ACCELERATION = 1000.0
export(float) var AIR_DECCELERATION = 2000.0
export(float) var AIR_STEERING_POWER = 50.0

export(float) var JUMP_HEIGHT = 120.0
export(float) var JUMP_DURATION = 0.8

var enter_velocity = Vector2()

var max_air_speed = 0.0
var air_speed = 0.0
var air_velocity = Vector2()

var timer = 0.0
func initialize(speed, velocity):
	air_speed = speed
	max_air_speed = speed if speed > 0.0 else BASE_MAX_AIR_SPEED
	enter_velocity = velocity


# Initialize the state. E.g. change the animation
func enter(host):
	var input_direction = get_input_direction()
	update_look_direction(host, input_direction)
	timer = 0.0
	air_velocity = enter_velocity if input_direction else Vector2()
	host.get_node('AnimationPlayer').play('idle')


# Clean up the state. Reinitialize values like a timer
func exit(host):
	host.get_node("Pivot").position.y = 0.0 


func update(host, delta):
	var input_direction = get_input_direction()
	update_look_direction(host, input_direction)

	move_horizontally(host, delta, input_direction)

	#FIXME: Cambiarlo por on_Tween_tween_completed??
	timer += delta
	if timer >= JUMP_DURATION:
		return "move"
	animate_jump_height(host)

func move_horizontally(host, delta, direction):
	if direction:
		air_speed += AIR_ACCELERATION * delta
	else:
		air_speed -= AIR_DECCELERATION * delta
	air_speed = clamp(air_speed, 0, max_air_speed)

	var target_velocity = air_speed * direction.normalized()
	var steering_velocity = (target_velocity - air_velocity).normalized() * AIR_STEERING_POWER
	air_velocity += steering_velocity

	host.move_and_slide(air_velocity)


func animate_jump_height(host):
	var height = pow(sin(timer / JUMP_DURATION * PI), 0.7) * JUMP_HEIGHT
	host.get_node("Pivot").position.y = -height
#	var shadow_scale = 1.0 - value / JUMP_HEIGHT * 0.5
#	$Shadow.scale = Vector2(shadow_scale, shadow_scale)








