class_name Satellite extends Building


func initialize(pos: Vector2, id: int):
	super(pos, id)
	if is_owner(multiplayer.get_unique_id()):
		Util.building_controller.subscribe(self)

func _exit_tree():
	if is_owner(multiplayer.get_unique_id()):
		Util.building_controller.unsubscribe(self)
