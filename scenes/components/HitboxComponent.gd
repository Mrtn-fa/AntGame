extends Area2D
class_name HitboxComponent

@export var health_component : HealthComponent

func damage(from: Node):
	if health_component:
		health_component.damage(from)
