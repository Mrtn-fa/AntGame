class_name Building extends StaticBody2D

@onready var health = $HealthComponent
var player_id : int

func is_owner(p_id:int):
	return player_id == p_id

func receive_damage(from: Unit):
	Debug.dprint("ouch!")
	health.get_damage(from)

@rpc("any_peer", "call_local")
func rip():
	self.queue_free()

@rpc("any_peer", "call_local")
func initialize(pos: Vector2, id: int):
	position = pos
	player_id = id
	set_multiplayer_authority(player_id)
	#modulate = Game.get_player(player_id).get_color()

func _ready():
	Debug.dprint("built!")
