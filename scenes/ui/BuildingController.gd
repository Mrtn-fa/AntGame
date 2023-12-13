extends Node2D

var build_mode = false

var build_type = "satellite" # Change this later when multiple building types exist
var build_cost = 0
var build_material = "Wood"

var drop_off_list = {}

func subscribe(node):
	drop_off_list[node] = null
	
func unsubscribe(node):
	drop_off_list.erase(node)

func get_nearest_drop_off(pos):
	var nearest = Game.get_current_player().main_building
	var nearest_distance = nearest.get_global_position().distance_to(pos)
	
	for node in drop_off_list:
		var dist = node.get_global_position().distance_to(pos)
		if dist < nearest_distance:
			nearest = node
			nearest_distance = dist
	
	return nearest


var buildings = {
	"satellite": preload("res://scenes/buildings/satellite_building.tscn"),
	"satelliteghost": preload("res://scenes/buildings/ghosts/satellite_ghost.tscn")
}


# Called when the node enters the scene tree for the first time.
func _ready():
	Util.building_controller = self
	pass # Replace with function body.


func exit_build_mode():
	build_mode = false
	$Sprite2D.texture = null


func unblock_tiles(global_pos):
	var cell_pos = %TileMap.local_to_map(global_pos)
	var other_1 = %TileMap.get_neighbor_cell(cell_pos, TileSet.CELL_NEIGHBOR_TOP_RIGHT_SIDE)
	var other_2 = %TileMap.get_neighbor_cell(cell_pos, TileSet.CELL_NEIGHBOR_TOP_CORNER)
	var other_3 = %TileMap.get_neighbor_cell(cell_pos, TileSet.CELL_NEIGHBOR_TOP_LEFT_SIDE)
	
	Util.main.change_tile.rpc(cell_pos, Vector2(2, 1))
	Util.main.change_tile.rpc(other_1, Vector2(2, 1))
	Util.main.change_tile.rpc(other_2, Vector2(2, 1))
	Util.main.change_tile.rpc(other_3, Vector2(2, 1))


func enter_build_mode(building, _build_cost, _build_material):
	build_cost = _build_cost
	build_material = _build_material
	build_type = building
	var player = Game.get_current_player().id
	var building_scene = buildings[build_type]
	var building_instance = building_scene.instantiate()
	$Sprite2D.texture = building_instance.define_sprite(player)
	$Sprite2D.position = building_instance.get_node("Sprite2D").position
	build_mode = true
	building_instance.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player = Game.get_current_player().id
	var global_mouse_pos = get_global_mouse_position()
	var mouse_cell_pos = %TileMap.local_to_map(global_mouse_pos)
	var mouse_cell_pos_global = %TileMap.map_to_local(mouse_cell_pos)
	global_position = mouse_cell_pos_global

	#if not build_mode:
		#if Input.is_action_just_pressed("Build"):
			#var building_scene = buildings[build_type]
			#var building_instance = building_scene.instantiate()
			#$Sprite2D.texture = building_instance.define_sprite(player)
			#$Sprite2D.position = building_instance.get_node("Sprite2D").position
			#build_mode = true
			#building_instance.queue_free()
	#else:
	#if Input.is_action_just_pressed("Build"):
		#exit_build_mode()
		#return
	
	#2, 1
	if build_mode:
		if Input.is_action_just_pressed("Command"):
			exit_build_mode()
		
		var other_1 = %TileMap.get_neighbor_cell(mouse_cell_pos, TileSet.CELL_NEIGHBOR_TOP_RIGHT_SIDE)
		var other_2 = %TileMap.get_neighbor_cell(mouse_cell_pos, TileSet.CELL_NEIGHBOR_TOP_CORNER)
		var other_3 = %TileMap.get_neighbor_cell(mouse_cell_pos, TileSet.CELL_NEIGHBOR_TOP_LEFT_SIDE)
		
		var data_0 = %TileMap.get_cell_tile_data(0, mouse_cell_pos)
		var data_1 = %TileMap.get_cell_tile_data(0, other_1)
		var data_2 = %TileMap.get_cell_tile_data(0, other_2)
		var data_3 = %TileMap.get_cell_tile_data(0, other_3)
		
		var can_build = (data_0 and data_0.get_navigation_polygon(0)) and \
			(data_1 and data_1.get_navigation_polygon(0)) and \
			(data_2 and data_2.get_navigation_polygon(0)) and \
			(data_3 and data_3.get_navigation_polygon(0))
		
		var player_node = Game.get_current_player().player_node
		
		can_build = can_build and player_node.is_valid_transaction(build_cost, build_material)

		if not can_build:
			$Sprite2D.modulate = Color(1.0, 0.0, 0.0, 0.5)
		else:
			$Sprite2D.modulate = Color(1.0, 1.0, 1.0, 0.5)
		
		if Input.is_action_just_pressed("LeftClick"):
			if not can_build:
				exit_build_mode()
				return
			
			player_node.subtract_if_valid(build_cost, build_material)
			
			#Util.main.change_tile.rpc(mouse_cell_pos, Vector2(0, 1))
			#
			#Util.main.change_tile.rpc(other_1, Vector2(0, 1))
			#Util.main.change_tile.rpc(other_2, Vector2(0, 1))
			#Util.main.change_tile.rpc(other_3, Vector2(0, 1))
			
			build_type = build_type + "ghost"
			
			Util.main.spawn_building(global_position, build_type)
			exit_build_mode()
			return
