extends OnGround




# Initialize the state. E.g. change the animation
func enter(host):
	host.get_node('AnimationPlayer').play('Idle')


func handle_input(host, event):
	return .handle_input(host, event)


func update(host, delta):
	var input_direction = get_input_direction()
	if input_direction:
		return "move"
