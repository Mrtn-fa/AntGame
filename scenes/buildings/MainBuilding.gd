class_name MainBuilding extends Building

@onready var sprite = $Sprite2D
@onready var spawn1 = $Position1
@onready var spawn2 = $Position2
@onready var pos = 0
@onready var portrait_sprite = $Sprite2DPortrait

var base_unit = "ant_worker"
var unit_cost = 5
var unit_material = "Sugar"


func receive_from(unit: Unit):
	# TIME CONSTRAINT: see satellitE_building, i literally copypasted this function lol
	# should be inheritance, sorry
	var player = Game.get_current_player().player_node
	player.add_material(unit)
	pass


# Called when the node enters the scene tree for the first time.
func _ready():
	Util.houses.append(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$TimeRemaining.text = "%s" % roundf($Timer.time_left)
	pass

func train():
	var player_role = Game.get_current_player().role
	if player_role == Game.Role.TERMITES:
		base_unit = "termite_worker"
	
	if not Game.get_current_player().player_node.subtract_if_valid(unit_cost, unit_material):
		return
	
	if $Timer.time_left==0 and (player_id == multiplayer.get_unique_id()):
		$Timer.start()
		$TimeRemaining.show()

func _on_timer_timeout():
	var spawn_x = randf_range(spawn1.global_position.x, spawn2.global_position.x)
	var spawn_y = randf_range(spawn1.global_position.y, spawn2.global_position.y)

	$TimeRemaining.hide()
	Util.main.spawn_unit(Vector2(spawn_x, spawn_y), base_unit)



func _exit_tree():
	if is_owner(multiplayer.get_unique_id()):
		Util.building_controller.unsubscribe(self)
