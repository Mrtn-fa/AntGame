extends CharacterBody2D

@export var player_id: int

func _ready():
	randomize()


@rpc("any_peer", "call_local")
func initialize(pos, id):
	position = pos
	player_id = id
	set_multiplayer_authority(player_id)
	if not is_multiplayer_authority():
		process_mode = Node.PROCESS_MODE_DISABLED
	
	modulate = Game.get_player(player_id).get_color()
	
func _process(delta):
	position += Vector2(randi_range(-100, 100), randi_range(-100, 100)) * delta
