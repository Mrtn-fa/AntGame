class_name Unit extends CharacterBody2D

var atk = 2
var material_count = 0
var speed = 50
var target_threshold = 8
var previous_position = Vector2.ZERO
var movement_target = Vector2.ZERO
var distance_to_target = Vector2.ZERO

@onready var map = $%TileMap
@onready var agent = $NavigationAgent2D
@onready var path_line = $DebugPath

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
	move_to_target(movement_target)


func state_move_transition():
	if agent.is_navigation_finished() or distance_to_target < target_threshold:
		set_state(STATE.IDLE)
	


func command(pos: Vector2):
	movement_target = pos
	agent.set_target_position(pos)
	set_state(STATE.MOVING)
	agent.is_target_reachable()
	path_line.points = agent.get_current_navigation_path()


func set_state(new_state: STATE):
	previous_state = state
	state = new_state


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
	
	agent.set_navigation_map(map)


func _update_sprite():
	if velocity.x < 0:
		$Sprite2D.flip_h = true
	elif velocity.x > 0:
		$Sprite2D.flip_h = false


func move_to_target(target: Vector2):
	previous_position = position
	distance_to_target = position.distance_to(target)
	#velocity = position.direction_to(target) * speed
	
	var direction = agent.get_next_path_position() - position
	velocity = direction.normalized() * speed
	agent.set_velocity(velocity)
	
	_update_sprite()
	#move_and_slide()

func _on_velocity_computed(safe_velocity):
	velocity = safe_velocity
	move_and_slide()


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

