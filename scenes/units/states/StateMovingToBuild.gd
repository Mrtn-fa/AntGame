extends State

class_name StateMovingToBuild

const label = "Moving to build"

func transition():
	if unit.has_arrived():
		unit.change_state(STATE.BUILDING)


func process():
	unit.move_to_target()
