extends Control

var selected
var selected_current_health
var selected_max_health


func init(node, sprite: Sprite2D, max_health: int, current_health: int):
	if is_instance_of(node, Unit):
		$SplitContainer/CenterContainer/PortraitTexture.texture = sprite.texture
	elif is_instance_of(node, Building):
		$SplitContainer/CenterContainer/PortraitTexture.texture = node.get_node("Sprite2D").texture
		
	$SplitContainer/Health.text = str(current_health)+"/"+str(max_health)
	var r = lerp(256, 0, current_health/max_health)
	var g = lerp(0, 256, current_health/max_health)
	$SplitContainer/Health.modulate = Color(r,g,0)
	selected = node
	selected_max_health = selected.health.MAX_HEALTH
	return self


# Called when the node enters the scene tree for the first time.
func _ready():
	$SplitContainer/CenterContainer.size_flags_vertical = SIZE_SHRINK_CENTER
	$SplitContainer/Health.size_flags_vertical = SIZE_SHRINK_CENTER


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (selected == null):
		queue_free()
		return
		
	if (selected.health == null):
		queue_free()
		return
	
	selected_current_health = selected.health.health
	var r = lerp(256, 0, selected_current_health/selected_max_health)
	var g = lerp(0, 256, selected_current_health/selected_max_health)
	$SplitContainer/Health.modulate = Color(r,g,0)
	$SplitContainer/Health.text = str(selected_current_health)+"/"+str(selected_max_health)
