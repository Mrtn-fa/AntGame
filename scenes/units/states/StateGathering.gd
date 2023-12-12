extends State

class_name StateGathering

const label = "Gathering"
var storage_radius = 32

func transition():
	if unit.is_full():
		var target = Util.building_controller.get_nearest_drop_off(unit.get_global_position())

		unit.navigation_component.set_target(target, storage_radius)
		unit.change_state(STATE.STORING)


func process():
	if unit.is_full():
		return

	var mat = unit.navigation_component.get_target()
	if mat == null:
		unit.change_state(STATE.IDLE)
	elif unit.can_attack:
		unit.interact(mat)

