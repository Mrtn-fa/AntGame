extends Node

var unit_controller = null
var main = null


func _ready():
	Debug.dprint("yooo")


func damp(current, target, factor, delta):
	var K = 1 - pow(factor, delta)
	return lerp(current, target, K)


func log_damp(current, target, factor, delta):
	var K = 1 - pow(factor, delta)
	return exp(lerp(log(current), log(target), factor))


func size_to_rect(vector: Vector2) -> PackedVector2Array:
	return PackedVector2Array([
		Vector2(0, 0),
		Vector2(vector.x, 0),
		Vector2(vector.x, vector.y),
		Vector2(0, vector.y)
	])
