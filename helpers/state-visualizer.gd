extends Label


func _ready():
	$'..'.connect('state_changed', self, '_on_Player_state_changed')


func _on_Player_state_changed(new_state):

	print(new_state)
	text = new_state
	

