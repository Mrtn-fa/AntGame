class_name Unit extends CharacterBody2D

var player_id: int

var state
var state_factory

@onready var health: HealthComponent = $HealthComponent
@export var atk = 2
var cooldown_time = 2 # Seconds
var cooldown = null
var can_attack = true

@onready var map = $%TileMap
@onready var navigation_component = $NavigationComponent
@export var speed = 50
var unit_group = null


# --- State ---

func command(amigo: Node2D):
	navigation_component.set_target(amigo)

	if not amigo or is_instance_of(amigo, TileMap):
		change_state(State.STATE.MOVING)
		return

	if is_instance_of(amigo, Unit):
		change_state(State.STATE.PURSUING if not amigo.is_owner(player_id) else State.STATE.MOVING)
		return


func change_state(state_value):
	if state != null:
		state.queue_free()
	state = state_factory.get_state(state_value).new()
	state.setup(self, state_value)
	add_child(state)

# --- --- ---

# --- Interaction ---

func interact(to: Node2D):
	if is_instance_of(to, Unit):
		to.receive(self)
		can_attack = false
	elif is_instance_of(to, uMaterial):
		to.get_damage(self)
		can_attack = false
	elif is_instance_of(to, MainBuilding):
		if to.is_owner(player_id):
			to.receive_from(self)
		else:
			to.receive_damage(self)

func receive(from: Node):
	if is_instance_of(from, Unit):
		health.get_damage(from)
		return

func _on_timeout():
	can_attack = true

# --- --- ---

# --- Movement ---

func update_sprite():
	if velocity.x < 0:
		$Sprite2D.flip_h = true
	elif velocity.x > 0:
		$Sprite2D.flip_h = false


func move_to_target():
	velocity = navigation_component.get_direction() * speed
	move_and_slide()
	update_sprite()


func get_unit_group():
	return unit_group


func get_target_distance():
	return position.distance_to(navigation_component.get_target().position)


func has_arrived():
	return navigation_component.is_target_reached()

# --- --- ---

# --- Instance ---

func is_owner(p_id:int):
	return player_id == p_id


@rpc("any_peer", "call_local")
func rip():
	self.queue_free()


@rpc("any_peer", "call_local")
func initialize(pos: Vector2, id: int):
	position = pos
	player_id = id
	set_multiplayer_authority(player_id)
	#modulate = Game.get_player(player_id).get_color()


func _ready():
	state_factory = StateFactory.new()
	change_state(State.STATE.IDLE)
	
	cooldown = Timer.new()
	cooldown.set_one_shot(false)
	cooldown.set_wait_time(cooldown_time)
	cooldown.timeout.connect(_on_timeout)
	add_child(cooldown)
	cooldown.start()
	if not is_multiplayer_authority():
		return


func _physics_process(_delta: float):
	if not is_multiplayer_authority():
		return
	
	state.process()
	state.transition()
	$Label.text = state.label

# --- --- ---
