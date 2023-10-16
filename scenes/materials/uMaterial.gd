class_name uMaterial extends Node2D

# @export var UNIDAD: Unit
@onready var health = $HealthComponent

@rpc("any_peer", "call_local")
func rip():
	self.queue_free()
	
# Gets attacked, respond with material
func get_damage(from: Unit):
	health.get_damage(from)
	from.receive(self)
	
#func _process(event):
#	if Input.is_action_just_pressed("attack_material"):
#		var a = Unit.new()
#		self.get_damage(a)
