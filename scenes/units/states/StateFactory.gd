extends Node

class_name StateFactory

var states


func _init():
	states = {
		State.STATE.IDLE: StateIdle,
		State.STATE.MOVING: StateMoving,
		State.STATE.MOVING_TO_GATHER: StateMovingToGather,
		State.STATE.GATHERING: StateGathering,
		State.STATE.STORING: StateStoring,
		State.STATE.PURSUING: StatePursuing,
		State.STATE.FIGHTING: StateFighting,
		State.STATE.MOVING_TO_BUILD: StateMovingToBuild,
		State.STATE.BUILDING: StateBuilding
	}


func get_state(state_value):
	if states.has(state_value):
		return states.get(state_value)
	else:
		printerr("No state", state_value, " in state factory")
