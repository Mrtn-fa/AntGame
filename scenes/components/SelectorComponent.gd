class_name SelectorComponent extends Node2D

@onready var rectangle = $Panel
@onready var parent_sprite = $"../Sprite2D"
var MARGIN = 6
var selected = false

# Moving
# Working/Fighting
# Idle

func get_player_id():
	return get_parent().player_id


func get_rect() -> Rect2:
	return Rect2(rectangle.global_position, rectangle.size)


func get_selected() -> bool:
	return selected


func set_selected(new_value: bool):
	# TODO: player check
	selected = new_value
	if selected:
		visible = true
	else:
		visible = false


func _ready():
	var rect_size = parent_sprite.texture.get_size() * parent_sprite.scale + Vector2(MARGIN, MARGIN)
	rectangle.size = rect_size
	rectangle.position.x = -rect_size.x / 2
	rectangle.position.y = -4
	rectangle.scale.y = 0.5
	set_selected(false)
	Util.unit_controller.subscribe(self)


func _exit_tree():
	Util.unit_controller.unsubscribe(self)
