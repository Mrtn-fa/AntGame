extends Node

class_name State

enum STATE {
	IDLE,
	MOVING,
	MOVING_TO_GATHER,
	GATHERING,
	STORING,
	PURSUING,
	FIGHTING,
	#MOVING_TO_BUILD,
	#BUILDING
}

var unit: Unit
var value: STATE

func setup(unit: Unit, value: STATE):
	self.unit = unit
	self.value = value


func _ready():
	return


func transition():
	return


func process():
	return
