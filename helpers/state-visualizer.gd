extends Label


func _ready():
	$'..'.connect('state_changed', self, '_on_Player_state_changed')


func _on_Player_state_changed(state_stack):

	print(state_stack[0].get_name())
	text = state_stack[0].get_name()
	

