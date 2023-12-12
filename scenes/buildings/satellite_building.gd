class_name Satellite extends Building

func receive_from(unit: Unit):
	Debug.dprint("gaming?")
	var player = Game.get_current_player().player_node
	player.add_material(unit)


func initialize(pos: Vector2, id: int):
	super(pos, id)
	if is_owner(multiplayer.get_unique_id()):
		Util.building_controller.subscribe(self)

func _exit_tree():
	if is_owner(multiplayer.get_unique_id()):
		Util.building_controller.unsubscribe(self)
