extends State

class_name StateMoving

const label = "Moving"

func transition():
	if unit.has_arrived():
		unit.change_state(STATE.IDLE)
		return
	
	for i in unit.get_slide_collision_count():
		var collider = unit.get_slide_collision(i).get_collider()
		if collider.has_method("get_unit_group"):
			if collider.state.value != STATE.MOVING and collider.get_unit_group() == unit.unit_group:
				unit.change_state(STATE.IDLE)


func process():
	unit.move_to_target()
