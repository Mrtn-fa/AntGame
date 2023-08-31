extends Camera2D

var mouse_position = Vector2()
var mouse_position_global = Vector2()

var drag_start_position = Vector2()
var drag_start_vector = Vector2()
var drag_end_position = Vector2()
var drag_end_vector = Vector2()

var is_dragging = false

signal area_seleced
signal start_move_selection

# Up to minute 22
# https://www.youtube.com/watch?v=JnuLDNeCuFw&t=5794s


@onready var selection_rectangle = $"../UI/SelectionRectangle"

func draw_area(s=true):
	selection_rectangle.size = Vector2(drag_start_vector - drag_end_vector).abs()
	var pos = Vector2(min(drag_start_vector.x, drag_end_vector.x), min(drag_start_vector.y, drag_end_vector.y))
	selection_rectangle.position = pos
	selection_rectangle.size *= int(s)

func _input(event):
	if event is InputEventMouse:
		mouse_position = event.position
		mouse_position_global = get_global_mouse_position()

func _process(delta):
	if Input.is_action_just_pressed("LeftClick"):
		drag_start_position = mouse_position_global
		drag_start_vector = mouse_position
		is_dragging = true
		
	if is_dragging:
		drag_end_position = mouse_position_global
		drag_end_vector = mouse_position
		draw_area()
		
	if Input.is_action_just_released("LeftClick"):
		if drag_start_vector.distance_to(drag_end_vector) > 20:
			emit_signal("area_selected")
		is_dragging = false
		draw_area(false)
