extends State

class_name StateBuilding

const label = "Bulding"
var build_radius = 32

func transition():
	if not is_instance_valid(unit.navigation_component.get_target()):
		unit.change_state(STATE.IDLE)


func process():
	var build = unit.navigation_component.get_target()
	if build == null:
		unit.change_state(STATE.IDLE)
	elif unit.can_attack:
		unit.interact(build)

