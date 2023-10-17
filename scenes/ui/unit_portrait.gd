extends Control

var selected_unit
var selected_unit_current_health
var selected_unit_max_health


func init(unit:Unit, sprite: Sprite2D, max_health: int, current_health: int):
	$PortraitTexture.texture = sprite.texture
	$UnitHealth.text = str(current_health)+"/"+str(max_health)
	var r = lerp(256, 0, current_health/max_health)
	var g = lerp(0, 256, current_health/max_health)
	$UnitHealth.modulate = Color(r,g,0)
	selected_unit = unit
	selected_unit_max_health = selected_unit.health.MAX_HEALTH
	return self


# Called when the node enters the scene tree for the first time.
func _ready():
	$UnitHealth.visible = false
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (selected_unit == null):
		queue_free()
		return
		
	if (selected_unit.health == null):
		queue_free()
		return
	
	selected_unit_current_health = selected_unit.health.health
	var r = lerp(256, 0, selected_unit_current_health/selected_unit_max_health)
	var g = lerp(0, 256, selected_unit_current_health/selected_unit_max_health)
	#$UnitHealth.modulate = Color(r,g,0)
	#$UnitHealth.text = str(selected_unit_current_health)+"/"+str(selected_unit_max_health)
