extends Node2D
class_name HealthComponent

@export var MAX_HEALTH  = 10.0
@export var health : float

func _ready():
	health = MAX_HEALTH
	
func get_damage(from: Node):
	if is_instance_of(from, Unit):
		take_damage(from.atk)
	if health <= 0:
		Util.main.despawn_node(self.get_parent())
		
func take_damage(amount):
	health -= amount
	sync_health.rpc(health)

@rpc("any_peer")
func sync_health(new_health):
	health = new_health

func _process(delta):
	$Label.text = str(health)
