extends Motion

class_name OnGround


#FIXME: Move the events to an input class
func handle_input(host, event):
	if event.is_action_pressed('attack'):
		return null
	if event.is_action_pressed('jump'):
		return 'jump'
