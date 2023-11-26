extends State

class_name StateGathering

const label = "Gathering"
var storage_radius = 32

func transition():
	if unit.is_full():
		var main_building = Game.get_current_player().main_building
		unit.navigation_component.set_target(main_building.get_node("GatherPoint"), storage_radius)
		unit.change_state(STATE.STORING)


func process():
	if unit.is_full():
		return

	var mat = unit.navigation_component.get_target()
	if mat == null:
		unit.change_state(STATE.IDLE)
	elif unit.can_attack:
		unit.interact(mat)

