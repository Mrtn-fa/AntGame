extends State

class_name StateIdle

const label = "Idle"


func _ready():
	unit.navigation_component.set_target(null)


func transition():
	return


func process():
	unit.velocity = Vector2.ZERO
