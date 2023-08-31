extends Camera2D

# General
var mouse_position = Vector2()
var mouse_position_global = Vector2()

# Rectangle Selection
@onready var selection_rectangle = $"../UI/SelectionRectangle"
var drag_start_position = Vector2()
var drag_start_vector = Vector2()
var drag_end_position = Vector2()
var drag_end_vector = Vector2()
var is_dragging = false
signal area_seleced
signal start_move_selection

# Camera pan/zoom
var camera_target = Vector2(position.x, position.y)
var PAN_SPEED = 500.0
var PAN_FACTOR = 0.0001
var ZOOM_SPEED = 20
var ZOOM_MIN = 0.5
var ZOOM_MAX = 2.0
var ZOOM_FACTOR = 0.1
var zoom_value = 1.0
var zoom_target = zoom_value


func draw_selection_rectangle(s=true):
	selection_rectangle.size = Vector2(drag_start_vector - drag_end_vector).abs()
	var pos = Vector2(min(drag_start_vector.x, drag_end_vector.x), min(drag_start_vector.y, drag_end_vector.y))
	selection_rectangle.position = pos
	selection_rectangle.size *= int(s)


func process_selection_rectangle():
	if Input.is_action_just_pressed("LeftClick"):
		drag_start_position = mouse_position_global
		drag_start_vector = mouse_position
		is_dragging = true
		
	if is_dragging:
		drag_end_position = mouse_position_global
		drag_end_vector = mouse_position
		draw_selection_rectangle()
		
	if Input.is_action_just_released("LeftClick"):
		if drag_start_vector.distance_to(drag_end_vector) > 20:
			emit_signal("area_selected")
		is_dragging = false
		draw_selection_rectangle(false)


func process_camera(delta: float) -> void:
	var position_delta = Input.get_vector("PanLeft", "PanRight", "PanUp", "PanDown") * PAN_SPEED * delta / zoom_value
	camera_target += position_delta
	position = Util.damp(position, camera_target, PAN_FACTOR, delta)
	
	var zoom_axis = int(Input.is_action_just_released("ZoomIn")) - int(Input.is_action_just_released("ZoomOut"))
	var zoom_delta = zoom_axis * ZOOM_SPEED * delta
	zoom_target += zoom_delta
	zoom_target = clamp(zoom_target, ZOOM_MIN, ZOOM_MAX)
	zoom_value = Util.log_damp(zoom_value, zoom_target, ZOOM_FACTOR, delta)
	zoom.x = zoom_value
	zoom.y = zoom_value


func _process(delta: float) -> void:
	process_camera(delta)
	process_selection_rectangle()


func _input(event):
	if event is InputEventMouse:
		mouse_position = event.position
		mouse_position_global = get_global_mouse_position()
	
