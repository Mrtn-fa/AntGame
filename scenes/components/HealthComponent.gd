extends Node2D
class_name HealthComponent

@export var MAX_HEALTH  = 10.0
var health : float

func _ready():
	health = MAX_HEALTH
	
func get_damage(from: Node):
	if from is Unit:
		print("attack from Unit")
		health -= from.atk
		print("actual health", health)
	if health <= 0:
		Util.main.despawn_node(self.get_parent())

func _process(delta):
	$Label.text = str(health)
