# Base class all states inherit from
# Stores a ref to the FSM node, and the STATE_IDS
extends Motion

const BUMP_DURATION = 0.2
const BUMP_DISTANCE = 60
const BUMP_HEIGHT = 50

var timer = 0.0
# Initialize the state. E.g. change the animation

func enter(host):
	var input_direction = get_input_direction()
	update_look_direction(host, input_direction)
	timer = 0.0
	velocity = Vector2.ZERO
	host.get_node('AnimationPlayer').play('idle')
	
	velocity = Vector2.ZERO
	host.get_node('AnimationPlayer').stop()
			
	host.get_node('Tween').interpolate_property(host, 'position', host.position, host.position + BUMP_DISTANCE * -last_move_direction,BUMP_DURATION, Tween.TRANS_LINEAR, Tween.EASE_IN)
	host.get_node('Tween').interpolate_method(host, '_animate_bump_height', 0, 1, BUMP_DURATION, Tween.TRANS_LINEAR, Tween.EASE_IN)
	host.get_node('Tween').start() 


# Clean up the state. Reinitialize values like a timer
func exit(host):
	host.get_node("Pivot").position.y = 0.0


func update(host, delta):
	#FIXME: Cambiarlo por on_Tween_tween_completed??
	timer += delta
	if timer >= BUMP_DURATION:
		emit_signal("finished", "move")
	_animate_bump_height(host)


func _animate_bump_height(host) -> void:
	var height = pow(sin(timer / BUMP_DURATION * PI), 0.7) * BUMP_HEIGHT
	host.get_node("Pivot").position.y = -height