extends Node

var unit_controller = null
var building_controller = null
var building_container = null
var main = null
var units = null
var houses = [];
var unit_container = null
var you_lose = null
var you_win = null


func damp(current, target, factor, delta):
	var K = 1 - pow(factor, delta)
	return lerp(current, target, K)


func log_damp(current, target, factor, delta):
	var K = 1 - pow(factor, delta)
	return exp(lerp(log(current), log(target), K))


func size_to_rect(vector: Vector2) -> PackedVector2Array:
	return PackedVector2Array([
		Vector2(0, 0),
		Vector2(vector.x, 0),
		Vector2(vector.x, vector.y),
		Vector2(0, vector.y)
	])
