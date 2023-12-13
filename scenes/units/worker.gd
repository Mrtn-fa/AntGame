class_name Worker extends Unit

var RESOURCE_MAX = 8
var material_count = 0
var material_type = ''
var current_resource_node = null


func subtract_material(qtt:int):
	material_count -= qtt


func get_current_material():
	return [material_count, material_type]


func is_full():
	return material_count == RESOURCE_MAX


func command(amigo: Node2D):
	super(amigo)
	
	if is_instance_of(amigo, uMaterial):
		current_resource_node = navigation_component.get_target()
		change_state(State.STATE.MOVING_TO_GATHER)
		return

	if is_instance_of(amigo, Building):
		if amigo.is_owner(player_id):
			if is_instance_of(amigo, MainBuilding) or is_instance_of(amigo, Satellite):
				change_state(State.STATE.STORING)
			elif is_instance_of(amigo, Ghost):
				change_state(State.STATE.MOVING_TO_BUILD)
		else:
			change_state(State.STATE.PURSUING)
		return


func receive(from: Node):
	super(from)
	if is_instance_of(from, uMaterial):
		self.material_count = min(self.material_count+self.atk, RESOURCE_MAX)
		return
