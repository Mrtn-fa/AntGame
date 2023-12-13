extends Ghost

const alt_texture_path = "res://resources/sprites/termite_barracks_ghost.png"
@onready var alt_texture = preload(alt_texture_path)

func initialize(pos: Vector2, id: int):
	super(pos, id)
	
	if Game.get_player(player_id).role == Game.Role.TERMITES:
		$Sprite2D.texture = alt_texture

func _ready():
	super()
	real_building = "barracks"
