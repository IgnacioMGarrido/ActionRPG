extends KinematicBody2D


class_name CharacterSM

signal state_changed

var look_direction = Vector2()

var current_state = null
var state_stack = []

onready var inputHandler = $"InputHandler"

onready var states_map = {
	'idle': $States/Idle,
	'move': $States/Move,
	'jump': $States/Jump,
	'bump': $States/Bump,
	'fall': $States/Fall,
	'spawn': $States/Spawn,
	'stagger': $States/Stagger
}

func _ready():
	state_stack.push_front(states_map['idle'])
	current_state = state_stack[0]
	_change_state('idle')
	for state_node in $States.get_children():
		state_node.connect("finished", self, "_change_state")
	for gap in get_tree().get_nodes_in_group('gap'):
		gap.connect('body_fell', self, '_on_Gap_body_fell')
	


# Delegate the call to the state
func _physics_process(delta):
	var new_state = current_state.update(self, delta)
	if new_state:
		_change_state(new_state)



func _on_AnimationPlayer_animation_finished(anim_name):

	var new_state = current_state._on_AnimationPlayer_animation_finished(anim_name)
	if new_state:
		_change_state(new_state)



func _input(event):
	var new_state = current_state.handle_input(self, event)
	if new_state:
		_change_state(new_state)


# Exit the current state, change it and enter the new one
func _change_state(state_name):
	current_state.exit(self)

	if state_name == 'previous':
		state_stack.pop_front()
	elif state_name in ['stagger', 'jump']:
		state_stack.push_front(states_map[state_name])
	else:
		state_stack[0] = states_map[state_name]
	
	# You can control the flow of states and transfer data between states here
	# It's better than doing it in the individual state objects so they don't get coupled with one another
	if state_name == 'jump':
		$States/Jump.initialize(current_state.speed, current_state.velocity)

	current_state = state_stack[0]
	
	if state_name != 'previous': 
		current_state.enter(self)
	emit_signal('state_changed', state_stack)


func _on_Gap_body_fell(rid):
	if rid == get_rid():
		_change_state('fall')

