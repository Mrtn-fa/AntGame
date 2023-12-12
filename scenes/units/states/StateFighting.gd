extends State

class_name StateFighting

const label = "Fighting"


func transition():
	var amigo = unit.navigation_component.get_target()
	if amigo == null:
		unit.change_state(STATE.IDLE)
		return

	if unit.get_target_distance() > 32:
		unit.navigation_component.refresh_target()
		unit.change_state(STATE.PURSUING)


func process():
	# Todo: Shove towards enemy/attack any nearby
	var amigo = unit.navigation_component.get_target()
	if amigo == null:
		unit.change_state(STATE.IDLE)
	elif unit.can_attack:
		unit.interact(amigo)
