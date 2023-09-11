extends Camera2D

# General
var mouse_position = Vector2()
var mouse_position_global = Vector2()
var mouse_in_window

# Camera pan
var PAN_SPEED = 400.0
var PAN_FACTOR = 0.0001
var PAN_MARGIN = 5
var pan_target = Vector2(position.x, position.y)

# Camera zoom
var ZOOM_SPEED = 12
var ZOOM_MIN = 0.75
var ZOOM_MAX = 2
var ZOOM_FACTOR = 0.01
var zoom_value = 1.0
var zoom_target = zoom_value


func process_camera(delta: float) -> void:
	if not Util.unit_controller.is_dragging:
		var viewport_size = get_viewport_rect().size
		var pan_axis = Input.get_vector("PanLeft", "PanRight", "PanUp", "PanDown")
		
		if mouse_in_window:
			pan_axis.x += int(mouse_position.x > viewport_size.x - PAN_MARGIN) - int(mouse_position.x < PAN_MARGIN)
			pan_axis.y += int(mouse_position.y > viewport_size.y - PAN_MARGIN) - int(mouse_position.y < PAN_MARGIN)
			pan_axis = pan_axis.normalized()
		
		var pan_delta = pan_axis * PAN_SPEED * delta / zoom_value
		pan_target += pan_delta
		
		var zoom_axis = int(Input.is_action_just_released("ZoomIn")) - int(Input.is_action_just_released("ZoomOut"))
		var zoom_delta = zoom_axis * ZOOM_SPEED * delta
		zoom_target += zoom_delta
	
	position = Util.damp(position, pan_target, PAN_FACTOR, delta)
	zoom_target = clamp(zoom_target, ZOOM_MIN, ZOOM_MAX)
	zoom_value = Util.log_damp(zoom_value, zoom_target, ZOOM_FACTOR, delta)
	zoom.x = zoom_value
	zoom.y = zoom_value


func _process(delta: float) -> void:
	process_camera(delta)


func _input(event):
	if event is InputEventMouse:
		mouse_position = event.position
		mouse_position_global = get_global_mouse_position()


func _notification(what):
	if what == NOTIFICATION_WM_MOUSE_ENTER:
		mouse_in_window = true
	elif what == NOTIFICATION_WM_MOUSE_EXIT:
		mouse_in_window = false
