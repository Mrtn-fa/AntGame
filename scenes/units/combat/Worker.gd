class_name Worker extends Unit

var RESOURCE_MAX = 4
var material_count = 0
var material_type = ''
var current_resource_node = null

func command(amigo: Node2D):
	super.command(amigo)
	if is_instance_of(amigo, uMaterial):
		current_resource_node = navigation_component.get_target()
		change_state(State.STATE.MOVING_TO_GATHER)
	elif is_instance_of(amigo, Building):
		change_state(State.STATE.STORING if amigo.is_owner(player_id) else State.STATE.PURSUING)
		
func subtract_material(qtt:int):
	material_count -= qtt

func receive(from: Node):
	super.receive(from)
	if is_instance_of(from, uMaterial):
		self.material_count = min(self.material_count+self.atk, RESOURCE_MAX)

func get_current_material():
	return [material_count, material_type]

func is_full():
	return material_count == RESOURCE_MAX
	
