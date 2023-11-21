extends State

class_name StateMovingToGather

const label = "Moving to gather"

func transition():
	if unit.has_arrived():
		unit.change_state(STATE.GATHERING)


func process():
	unit.move_to_target()
