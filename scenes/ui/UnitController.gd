extends Node2D

# Rectangle
@onready var rectangle = $Panel
var mouse_position = Vector2()
var mouse_position_global = Vector2()
var drag_start = Vector2.ZERO
var drag_end = Vector2.ZERO
var bottom_right = Vector2.ZERO
var is_dragging = false
var selection_box = Rect2()
var unit_selection = false
var building_selection = true

# Selection Components
var selected_units = []
var selected_building = null
var selection_components = {}  # (set)
func subscribe(node):
	selection_components[node] = null
func unsubscribe(node):
	selection_components.erase(node)
	
var portrait_scene = load("res://scenes/ui/unit_portrait.tscn")	

func create_portrait(selected_node , texture: Sprite2D, max_health: int, current_health: int):
	var portrait = portrait_scene.instantiate()
	if is_instance_of(selected_node, BuildingSelectorComponent):
		texture.scale *= 0.25
		
	return portrait.init(selected_node, texture, max_health, current_health)

func get_amigo() -> Node2D:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = get_global_mouse_position()
	var result = space_state.intersect_point(query)
	if len(result) >= 1:
		var amigo = result[0]
		print("amigo:", amigo)
		return amigo["collider"]
	return null
		

var rng = RandomNumberGenerator.new()

func _command_group():
	var unit_group = rng.randi()
	var current_amigo: Node2D = get_amigo()
	for selector in selected_units: #TODO: Bug futuro Unidades eliminados
		var unit = selector.get_parent()
		unit.unit_group = unit_group
		unit.command(current_amigo)

func select_area():
	selected_units = []
	for node in selection_components:
		if node.get_player_id() == multiplayer.get_unique_id():
			if (node.global_position.x > position.x and node.global_position.x < bottom_right.x \
					and node.global_position.y > position.y and node.global_position.y < bottom_right.y):
				if is_instance_of(node, UnitSelectorComponent):
					selected_units.append(node)
					node.set_selected(true)
				if is_instance_of(node, BuildingSelectorComponent):
					selected_building = node
			else:
				node.set_selected(false)
	if selected_units.is_empty() and selected_building != null:
		selected_building.set_selected(true)
		for selected_unit in selected_units:
			selected_unit.set_selected(false)
	elif !selected_units.is_empty() and selected_building != null:
		selected_building.set_selected(false)
		selected_building = null

func select_point():
	selected_units = []
	selected_building = null
	var selection_found = false
	for node in selection_components:
		if node.get_player_id() == multiplayer.get_unique_id():
			if selection_found:
				node.set_selected(false)
			if node.get_rect().has_point(drag_end):
				if is_instance_of(node, UnitSelectorComponent):
					selected_units.append(node)
				elif is_instance_of(node, BuildingSelectorComponent):
					for selected_unit in selected_units:
						selected_unit.set_selected(false)
					selected_units = []
					selected_building = node
				node.set_selected(true)
				selection_found = true
			else:
				node.set_selected(false)
			

func draw(vis = true):
	position = Vector2(min(drag_start.x, drag_end.x), min(drag_start.y, drag_end.y))
	var rect_size = Vector2(drag_start - drag_end).abs() * int(vis)
	rectangle.size = rect_size


func get_selection():
	position += Vector2(1, 1)
	

func _ready():
	Util.unit_controller = self
	draw(false)

func _input(event):
	if event is InputEventMouse:
		mouse_position = event.position
		mouse_position_global = get_global_mouse_position()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("LeftClick"):
		drag_start = mouse_position_global
		is_dragging = true
		
	if is_dragging:
		drag_end = mouse_position_global
		draw()
	
	if Input.is_action_just_released("LeftClick"):
		bottom_right = Vector2(max(drag_start.x, drag_end.x), max(drag_start.y, drag_end.y))
		for n in Util.unit_container.get_children():
			Util.unit_container.remove_child(n)
			n.queue_free()
		if drag_start.distance_to(drag_end) > 20:
			select_area()
		else:
			select_point()
		for selector_unit in selected_units:
			var sprite = selector_unit.parent_sprite
			var unit = selector_unit.get_parent()
			var max_health = unit.health.MAX_HEALTH
			var current_health = unit.health.health
			var portrait = create_portrait(unit, sprite, max_health, current_health)
			Util.unit_container.add_child(portrait)
		if selected_building != null:
			var sprite = selected_building.parent_sprite
			var building = selected_building.get_parent()
			var max_health = building.health.MAX_HEALTH
			var current_health = building.health.health
			var portrait = create_portrait(building, sprite, max_health, current_health)
			Util.unit_container.add_child(portrait)
		is_dragging = false
		draw(false)
	
	if Input.is_action_just_released("Command"):
		_command_group()
