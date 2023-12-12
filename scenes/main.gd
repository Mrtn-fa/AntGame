extends Node2D

@export var player_scene: PackedScene
@onready var players: Node2D = $Players

var units = []
var unit_scenes = {
	"ant_worker": preload("res://scenes/units/specific/ant_worker.tscn"),
	"termite_worker": preload("res://scenes/units/specific/termite_worker.tscn"),
	"ant_grunt": preload("res://scenes/units/specific/ant_grunt.tscn"),
	"termite_grunt": preload("res://scenes/units/specific/termite_grunt.tscn")
}

func _ready() -> void:
	Util.main = self
	
	# Multiplayer
	for player_data in Game.players:
		var player = player_scene.instantiate()
		players.add_child(player)
		player.setup(player_data)
		player_data.player_node = player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	#$UI/Label.text = str(Engine.get_frames_per_second())

@rpc("any_peer", "call_local")
func spawn_server(pos, type):
	var unit = unit_scenes[type].instantiate()
	var player_id = multiplayer.get_remote_sender_id()

	if player_id == 0:
		player_id = 1
		
	Util.units.add_child(unit, true)
	
	pos.x += randf_range(-1.0, 1.0)
	pos.y += randf_range(-1.0, 1.0)
	
	unit.initialize.rpc(pos, player_id)

@rpc("any_peer", "call_local")
func spawn_building_server(pos, type):
	var building_scene = Util.building_controller.buildings[type]
	var building = building_scene.instantiate()
	var player_id = multiplayer.get_remote_sender_id()
	
	if player_id == 0:
		player_id = 1
	
	%YSort.add_child(building, true)
	
	building.initialize.rpc(pos, player_id)

@rpc("any_peer", "call_local")
func change_tile(pos: Vector2, atlas_position: Vector2):
	%TileMap.set_cell(0, pos, 0, atlas_position)
	
func spawn_building(pos, type):
	if is_multiplayer_authority():
		spawn_building_server(pos, type)
	else:
		spawn_building_server.rpc(pos, type)

func spawn_unit(pos, type):
	if is_multiplayer_authority():
		spawn_server(pos, type)
	else:
		spawn_server.rpc(pos, type)

@rpc("any_peer", "call_local")
func despawn_node_server(node: Node):
	node.rip.rpc()

func despawn_node(node: Node):
	if is_multiplayer_authority():
		despawn_node_server(node)
	else:
		despawn_node_server.rpc(node)
