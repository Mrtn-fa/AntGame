class_name Player extends Node2D

const STARTING_WOOD = 100
const STARTING_SUGAR = 100
var wood : int
var sugar: int

var base_unit = ""
var grunt_unit = "" 


func _ready():
	wood = STARTING_WOOD
	sugar = STARTING_SUGAR
	
func is_valid_transaction(qtt:int, material_type:String):
	var material
	if material_type == 'Wood':
		material = wood
	elif material_type == 'Sugar':
		material = sugar
	return material-qtt>=0

func add_material(unit: Unit):
	var material_data = unit.get_current_material()
	var material_count = material_data[0]
	var material_type = material_data[1]
	
	if material_type == 'Wood':
		wood += material_count
	elif material_type == 'Sugar':
		sugar += material_count
	unit.subtract_material(material_count)
	#Debug.dprint("unit has " + str(unit.material_count) + ' units of resource')
	
#TODO: corregir magic strings
func subtract_material(qtt:int, material_type:String):
	if material_type == 'Wood':
		wood-=qtt
	elif material_type == 'Sugar':
		sugar-=qtt


func setup(player_data: Game.PlayerData):
	set_multiplayer_authority(player_data.id)
	name = str(player_data.id)
	var house = Util.houses[int(player_data.role) - 1]
	house.player_id = player_data.id
	player_data.main_building = house
	player_data.enemy_main_building = Util.houses[int(player_data.role) - 2]
	house.get_node("HealthComponent/Label").modulate = player_data.get_color()
	
	if (player_data.role == Game.Role.ANTS):
		base_unit = "ant_worker"
		grunt_unit = "ant_grunt"
	elif (player_data.role == Game.Role.TERMITES):
		base_unit = "termite_worker"
		grunt_unit = "termite_grunt"


func _process(delta):
	if Game.get_current_player().main_building == null:
		Util.you_lose.visible = true
	
	if Game.get_current_player().enemy_main_building == null:
		Util.you_win.visible = true


@rpc
func test():
#	if is_multiplayer_authority():
	Debug.dprint("test - player: %s" % name, 30)


func _input(event: InputEvent) -> void:
	if is_multiplayer_authority():
		if event.is_action_pressed("test"):
			print(Game.get_current_player().player_node)
			test.rpc_id(1)
		if event.is_action_pressed("DebugSpawnWorker"):
			Util.main.spawn_unit(get_global_mouse_position(), base_unit)
		if event.is_action_pressed("DebugSpawnWorkerTermite"):
			Util.main.spawn_unit(get_global_mouse_position(), grunt_unit)
