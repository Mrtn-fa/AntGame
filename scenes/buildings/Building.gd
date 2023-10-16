class_name Building extends Node2D

@onready var health = $HealthComponent
var player_id : int

func is_owner(p_id:int):
	return player_id == p_id


func receive_damage(from: Unit):
	health.get_damage(from)

@rpc("any_peer", "call_local")
func rip():
	self.queue_free()
