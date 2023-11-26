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
		
		if Input.is_action_just_pressed("LeftClick"):
			Util.main.change_tile.rpc(mouse_cell_pos, Vector2(0, 1))
			Util.main.spawn_building(global_position, build_type)
			exit_build_mode()
			return
