class_name Barracks extends Building

const alt_texture_path = "res://resources/sprites/termite_barracks.png"
@onready var alt_texture = preload(alt_texture_path)

@onready var spawn1 = $Position1
@onready var spawn2 = $Position2

var base_unit = "ant_grunt"
var unit_cost = 15
var unit_material = "Sugar"


# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	$TimeRemaining.max_value = $Timer.wait_time


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$TimeRemaining.value = $Timer.time_left


func train():
	var player_role = Game.get_current_player().role
	if player_role == Game.Role.TERMITES:
		base_unit = "termite_grunt"
	
	if $Timer.time_left != 0:
		return
	
	if not Game.get_current_player().player_node.subtract_if_valid(unit_cost, unit_material):
		return
	
	if player_id == multiplayer.get_unique_id():
		$Timer.start()
		$TimeRemaining.show()

func _on_timer_timeout():
	var spawn_x = randf_range(spawn1.global_position.x, spawn2.global_position.x)
	var spawn_y = randf_range(spawn1.global_position.y, spawn2.global_position.y)

	$TimeRemaining.hide()
	Util.main.spawn_unit(Vector2(spawn_x, spawn_y), base_unit)


func define_sprite(pid):
	if Game.get_player(pid).role == Game.Role.TERMITES:
		return load(alt_texture_path)
	else:
		return $Sprite2D.texture


func initialize(pos: Vector2, id: int):
	super(pos, id)
	
	Util.building_controller.block_tiles(get_global_position())
	
	# código repetido pero filo
	if Game.get_player(player_id).role == Game.Role.TERMITES:
		$Sprite2D.texture = alt_texture

