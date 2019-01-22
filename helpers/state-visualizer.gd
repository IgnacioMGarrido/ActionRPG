extends Label

const STATE_STRINGS = [
  "SPAWN",
  "IDLE",
  "MOVE",
  "JUMP",
  "BUMP",
  "FALL"
]


func _ready():
	$'..'.connect('state_changed', self, '_on_Player_state_changed')


func _on_Player_state_changed(new_state):
	text = STATE_STRINGS[new_state]