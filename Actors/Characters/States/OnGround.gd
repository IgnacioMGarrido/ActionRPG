extends Motion

class_name OnGround


#FIXME: Move the events to an input class
func handle_input(host, event):
	if inputHandler.is_attack_activated():
		return null
	if inputHandler.is_jump_activated():
		return 'jump'
