extends OnGround

const WALK_MASS = 10.0
const RUN_MASS = 3.0
const STOP_THRESHOLD = 10



var current_mass = 0.0

func enter(host):
	speed = 0.0
	velocity = Vector2()

	var input_direction = get_input_direction()
	update_look_direction(host, input_direction)
	host.get_node('AnimationPlayer').play('walk')


func handle_input(host, event):
	return .handle_input(host, event)


func update(host, delta):
	var input_direction = get_input_direction()
	if not input_direction:
		return "idle"
	update_look_direction(host, input_direction)

	speed = get_current_speed()
	var collision_info = move(host, speed, input_direction)
	if not collision_info:
		return
	if speed == MAX_RUN_SPEED and collision_info.collider.is_in_group('environment'):
		return "bump"


func move(host, speed, direction):
	var target_velocity = direction.normalized() * speed
	var steering = target_velocity - velocity
	
	current_mass = RUN_MASS if speed == max_speed else WALK_MASS
	
	velocity += steering / current_mass
	host.move_and_slide(velocity, Vector2(), 5, 2)
	
	var slide_count : int = host.get_slide_count()
	return host.get_slide_collision(slide_count - 1) if slide_count else null
