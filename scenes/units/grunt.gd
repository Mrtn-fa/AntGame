class_name Grunt extends Unit


func command(amigo: Node2D):
	super(amigo)
	
	if is_instance_of(amigo, Building):
		if amigo.is_owner(player_id):
			return
		else:
			change_state(State.STATE.PURSUING)
		return
