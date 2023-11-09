extends State

class_name StatePursuing

const label = "Pursuing"


func transition():
	if unit.has_arrived():
		unit.change_state(STATE.FIGHTING)


func process():
	unit.move_to_target()
