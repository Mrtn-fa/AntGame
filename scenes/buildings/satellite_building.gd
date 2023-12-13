class_name Satellite extends Building

const alt_texture_path = "res://resources/sprites/termite_satellite.png"
@onready var alt_texture = preload(alt_texture_path)

func receive_from(unit: Unit):
	var player = Game.get_current_player().player_node
	player.add_material(unit)

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
	
	if is_owner(multiplayer.get_unique_id()):
		Util.building_controller.subscribe(self)


func _exit_tree():
	if is_owner(multiplayer.get_unique_id()):
		Util.building_controller.unsubscribe(self)
