class_name Building extends StaticBody2D

@onready var health = $HealthComponent
var player_id : int
var this_sprite = null
var unblocks = true

func is_owner(p_id:int):
	return player_id == p_id

func receive_damage(from: Unit):
	health.get_damage(from)

@rpc("any_peer", "call_local")
func rip():
	if unblocks:
		Util.building_controller.unblock_tiles(get_global_position())
	self.queue_free()

@rpc("any_peer", "call_local")
func initialize(pos: Vector2, id: int):
	position = pos
	player_id = id
	set_multiplayer_authority(player_id)
	#modulate = Game.get_player(player_id).get_color()
	$BuildingSelectorComponent.modulate = Game.get_player(player_id).get_color()


func _ready():
	pass
