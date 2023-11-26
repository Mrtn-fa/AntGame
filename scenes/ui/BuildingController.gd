extends Node2D

var build_mode = false

var build_type = "satellite" # Change this later when multiple building types exist


var buildings = {
	"satellite": preload("res://scenes/buildings/satellite_building.tscn")
}


# Called when the node enters the scene tree for the first time.
func _ready():
	Util.building_controller = self
	pass # Replace with function body.

func exit_build_mode():
	build_mode = false
	$Sprite2D.texture = null


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var global_mouse_pos = get_global_mouse_position()
	var mouse_cell_pos = %TileMap.local_to_map(global_mouse_pos)
	var mouse_cell_pos_global = %TileMap.map_to_local(mouse_cell_pos)
	global_position = mouse_cell_pos_global



	if not build_mode:
		if Input.is_action_just_pressed("Build"):
			var building_scene = buildings[build_type]
			var building_instance = building_scene.instantiate()
			$Sprite2D.texture = building_instance.get_node("Sprite2D").texture
			$Sprite2D.position = building_instance.get_node("Sprite2D").position
			build_mode = true
			building_instance.queue_free()
	else:
		if Input.is_action_just_pressed("Build"):
			exit_build_mode()
			return
		
		var other_1 = %TileMap.get_neighbor_cell(mouse_cell_pos, TileSet.CELL_NEIGHBOR_TOP_RIGHT_SIDE)
		var other_2 = %TileMap.get_neighbor_cell(mouse_cell_pos, TileSet.CELL_NEIGHBOR_TOP_CORNER)
		var other_3 = %TileMap.get_neighbor_cell(mouse_cell_pos, TileSet.CELL_NEIGHBOR_TOP_LEFT_SIDE)
		
		var can_build = %TileMap.get_cell_tile_data(0, mouse_cell_pos).get_navigation_polygon(0) and \
			%TileMap.get_cell_tile_data(0, other_1).get_navigation_polygon(0) and \
			%TileMap.get_cell_tile_data(0, other_2).get_navigation_polygon(0) and \
			%TileMap.get_cell_tile_data(0, other_3).get_navigation_polygon(0)

		if not can_build:
			$Sprite2D.modulate = Color(1.0, 0.0, 0.0, 0.5)
			return
		else:
			$Sprite2D.modulate = Color(1.0, 1.0, 1.0, 0.5)
		
		if Input.is_action_just_pressed("LeftClick"):
			Util.main.change_tile.rpc(mouse_cell_pos, Vector2(0, 1))
			
			Util.main.change_tile.rpc(other_1, Vector2(0, 1))
			Util.main.change_tile.rpc(other_2, Vector2(0, 1))
			Util.main.change_tile.rpc(other_3, Vector2(0, 1))
			
			Util.main.spawn_building(global_position, build_type)
			exit_build_mode()
			return
