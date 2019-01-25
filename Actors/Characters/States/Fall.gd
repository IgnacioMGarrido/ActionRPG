# Base class all states inherit from
# Stores a ref to the FSM node, and the STATE_IDS
extends Motion

const FALL_DURATION = 0.4
const GAP_SIZE = Vector2(128, 80)

var timer = 0.0
# Initialize the state. E.g. change the animation
func enter(host):
	timer = 0.0
	velocity = Vector2.ZERO
	host.get_node('Tween').interpolate_property(host, 'scale', host.scale, Vector2(0,0), FALL_DURATION, Tween.TRANS_QUAD, Tween.EASE_IN)
	host.get_node('Tween').start()


# Clean up the state. Reinitialize values like a timer
func exit(host):
	host.position -= last_move_direction * GAP_SIZE

func update(host, delta):
	timer += delta
	if timer >= FALL_DURATION:
		emit_signal("finished", "spawn")
