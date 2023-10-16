class_name Player
extends Node2D

const STARTING_WOOD = 100
var wood : int

func _ready():
	wood = STARTING_WOOD
	
func is_valid_transaction(qtt:int):
	return wood-qtt>=0

func add_material(unit: Unit):
	var material_data = unit.get_current_material()
	var material_count = material_data[0]
	var material_type = material_data[1]
	
	if material_type == 'Wood':
		wood += material_count
	# elif material_type == '...':
		# pass
	unit.subtract_material(material_count)
	
	
func subtract_wood(qtt:int):
	wood-=qtt


func setup(player_data: Game.PlayerData):
	set_multiplayer_authority(player_data.id)
	name = str(player_data.id)
	Debug.dprint(player_data.name, 30)
	Debug.dprint(player_data.role, 30)
	var house = Util.houses[int(player_data.role) - 1]
	house.player_id = player_data.id

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
