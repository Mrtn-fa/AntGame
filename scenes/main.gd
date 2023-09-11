extends Node2D

@export var player_scene: PackedScene
@onready var players: Node2D = $Players

var units = []
var unit_scene = preload("res://scenes/units/unit.tscn")

func _ready() -> void:
	Util.main = self
	
	# Multiplayer
	for player_data in Game.players:
		var player = player_scene.instantiate()
		players.add_child(player)
		player.setup(player_data)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$UI/Label.text = str(Engine.get_frames_per_second())

@rpc("any_peer")
func spawn_server(pos, type):
	var unit = unit_scene.instantiate()
	var player_id = multiplayer.get_remote_sender_id()

	if player_id == 0:
		player_id = 1
		
	$Units.add_child(unit, true)
	
	unit.initialize.rpc(pos, player_id)


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
