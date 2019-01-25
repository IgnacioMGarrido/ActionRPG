extends State


func enter(host):
	host.get_node('AnimationPlayer').play('stagger')


func _on_AnimationPlayer_animation_finished(anim_name):
	assert anim_name == 'stagger'
	emit_signal("finished", "previous")