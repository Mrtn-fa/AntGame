class_name Unit extends CharacterBody2D

var atk = 2
var material_count = 0
var speed = 50
var previous_position = Vector2.ZERO
var unit_group = null

@onready var map = $%TileMap
@onready var navigation_component = $NavigationComponent

@export var player_id: int
@export var Mat: uMaterial
@export var health: HealthComponent

enum STATE {
	IDLE,
	MOVING,
	#MOVING_TO_GATHER,
	#GATHERING,
	#PURSUING,
	#FIGHTING,
	#MOVING_TO_BUILD,
	#BUILDING
}
var state = STATE.IDLE
var previous_state = state


func state_idle_process():
	velocity = Vector2.ZERO


func state_idle_transition():
	return


func state_move_process():
	move_to_target()


func state_move_transition():
	if navigation_component.is_target_reached():
		set_state(STATE.IDLE)
		return
	
	for i in get_slide_collision_count():
		var collider = get_slide_collision(i).get_collider()
		if collider.has_method("get_unit_group"):
			if collider.state != STATE.MOVING and collider.get_unit_group() == unit_group:
				set_state(STATE.IDLE)


func command(pos: Vector2):
	navigation_component.set_target(pos)
	set_state(STATE.MOVING)


func set_state(new_state: STATE):
	previous_state = state
	state = new_state


func get_unit_group():
	return unit_group


func attack(to: Node):
	if is_instance_of(to, Unit):
		Debug.dprint("Unit attacked")
	elif is_instance_of(to, uMaterial):
		Debug.dprint("Material attacked")


func receive(from: Node):
	if is_instance_of(from, Unit):
		health.get_damage(from)
		print("unit receive damage")
	elif is_instance_of(from, uMaterial):
		self.material_count += atk
		print("unit received material")


@rpc("any_peer", "call_local")
func initialize(pos: Vector2, id: int):
	position = pos
	player_id = id
	set_multiplayer_authority(player_id)
	modulate = Game.get_player(player_id).get_color()


func _ready():
	if not is_multiplayer_authority():
		return


func _update_sprite():
	if velocity.x < 0:
		$Sprite2D.flip_h = true
	elif velocity.x > 0:
		$Sprite2D.flip_h = false


func move_to_target():
	previous_position = position
	velocity = navigation_component.get_direction() * speed
	move_and_slide()
	_update_sprite()


func _physics_process(_delta: float):
	if not is_multiplayer_authority():
		return

	match state:
		STATE.IDLE:
			state_idle_process()
			state_idle_transition()
		STATE.MOVING:
			state_move_process()
			state_move_transition()

