# Base class all states inherit from
# Stores a ref to the FSM node, and the STATE_IDS
extends Motion

const SPAWN_DURATION = 0.4

var timer = 0.0
# Initialize the state. E.g. change the animation
func enter(host):
	timer = 0.0
	velocity = Vector2.ZERO
	host.get_node('Tween').interpolate_property(host, 'scale', host.scale, Vector2(1, 1), SPAWN_DURATION, Tween.TRANS_QUAD, Tween.EASE_IN)
	host.get_node('Tween').start()


# Clean up the state. Reinitialize values like a timer
#func exit(host):
	#host.scale = Vector2(1,1)

func update(host, delta):
	timer += delta
	if timer >= SPAWN_DURATION:
		return "idle"
