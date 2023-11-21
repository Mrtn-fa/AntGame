extends Node2D

@export var target_threshold: int = 16

@onready var agent = $NavigationAgent2D
@onready var rays = [
	$RayUp,
	$RayLeftest,
	$RayLeft,
	$RayFront,
	$RayRight,
	$RayRightest,
	$RayDown
]


var distance_to_target = Vector2.ZERO
var interest = [0, 0, 0, 0, 0, 0, 0]
var target_node = null


func set_target(target: Object):
	var pos
	if not target or is_instance_of(target, TileMap):
		target_node = null
		pos = get_global_mouse_position()
	else:
		target_node = target
		pos = Vector2(target.get_position())
	agent.set_target_position(pos)
	return agent.is_target_reachable()


func refresh_target():
	var pos = Vector2(target_node.get_position())
	agent.set_target_position(pos)


func get_target():
	return target_node


# Condiciones para terminar la navegación (cualquiera sirve)
# 1. Se murió la meta
# 2. Está muy cerca a la meta
# 3. Se acabaron los puntos del camino calculado
func is_target_reached() -> bool:
	if target_node == null:
		return agent.is_navigation_finished()
	var distance = get_parent().position.distance_to(target_node.position)
	return distance < target_threshold or agent.is_navigation_finished()


func get_direction() -> Vector2:
	distance_to_target = global_position.distance_to(agent.get_final_position())
	var direction = global_position.direction_to(agent.get_next_path_position())
	rotation = direction.angle()
	return _set_interest()


func _set_interest() -> Vector2:
	var final_direction = 0
	interest = [0.59, 0.8, 0.79, 1, 0.8, 0.79, 0.6]
	for ray_index in rays.size():
		var ray = rays[ray_index]
		if ray.is_colliding():
			interest[ray_index] *= 0.01
		final_direction += ray.rotation * interest[ray_index]
	return Vector2(1, 0).rotated(final_direction + rotation)
	
