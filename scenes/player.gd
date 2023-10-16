class_name Player
extends Node2D

@export var resources : ResourceComponent

func transact_material(material:uMaterial, quantity:int):
	return resources.transact_material(material, quantity)
		
func add_material(material: uMaterial, quantity:int):
	return resources.add_material(material, quantity)
	
func subtract_material(material: uMaterial, quantity:int):
	return resources.subtract_material(material, quantity)

func setup(player_data: Game.PlayerData):
	set_multiplayer_authority(player_data.id)
	name = str(player_data.id)
	Debug.dprint(player_data.name, 30)
	Debug.dprint(player_data.role, 30)

@rpc
func test():
#	if is_multiplayer_authority():
	Debug.dprint("test - player: %s" % name, 30)

func _input(event: InputEvent) -> void:
	if is_multiplayer_authority():
		if event.is_action_pressed("test"):
			test.rpc_id(1)
		if event.is_action_pressed("DebugSpawnWorker"):
			Util.main.spawn_unit(get_global_mouse_position(), null)
