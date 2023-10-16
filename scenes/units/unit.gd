class_name Unit extends CharacterBody2D

var atk = 2
var RESOURCE_MAX = 10
var material_count = 0
var material_type = ''
var speed = 50
var cooldown_time = 2 # seconds
var cooldown = null
var can_attack = true
var previous_position = Vector2.ZERO
var unit_group = null
var current_resource_node = null
var current_target = null

@onready var map = $%TileMap
@onready var navigation_component = $NavigationComponent

@export var player_id: int
@export var Mat: uMaterial
@onready var health: HealthComponent = $HealthComponent


enum STATE {
	IDLE,
	MOVING,
	MOVING_TO_GATHER,
	GATHERING,
	STORING,
	PURSUING,
	FIGHTING,
	#MOVING_TO_BUILD,
	#BUILDING
}
var state = STATE.IDLE
var previous_state = state

@rpc("any_peer", "call_local")
func rip():
	self.queue_free()

func is_owner(p_id:int):
	return player_id == p_id

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

func state_moving_to_gather_process():
	move_to_target()
	
func state_moving_to_gather_transition():
	if navigation_component.is_target_reached():
		set_state(STATE.GATHERING)
		print("unit started gathering")
		return
		
# TODO: logic for going to the closest resource if it's destroyed
func state_gathering_process():
	var mat = navigation_component.get_target()
	if self.material_count == RESOURCE_MAX:
		print("full of resource!")
		return
	if mat == null: # resource is destroyed
		set_state(STATE.IDLE)
		navigation_component.set_target(null)
		print("te lo echaste")
		return
	if can_attack:
		print("gathering ", mat)
		self.interact(mat)
		can_attack = false
	
func state_gathering_transition():
	if self.material_count == RESOURCE_MAX:
		var main_building = Game.get_current_player().main_building
		navigation_component.set_target(main_building)
		set_state(STATE.STORING)
		
func state_storing_process():
	move_to_target()
	
func state_storing_transition():
	if navigation_component.is_target_reached():
		self.interact(navigation_component.get_target())
		if current_resource_node == null:
			set_state(STATE.IDLE)
		else:
			navigation_component.set_target(current_resource_node)
			set_state(STATE.MOVING_TO_GATHER)
		
func state_pursuing_process():
	move_to_target()
	
func state_pursuing_transition():
	if navigation_component.is_target_reached():
		set_state(STATE.FIGHTING)

func state_fighting_process():
	var amigo = navigation_component.get_target()
	if amigo == null:
		set_state(STATE.IDLE)
		navigation_component.set_target(null)
		print("te lo echaste")
		return
	if can_attack:
		self.interact(amigo)
		can_attack = false

func state_fighting_transition():
	var amigo = navigation_component.get_target()
	if amigo == null:
		set_state(STATE.IDLE)
		navigation_component.set_target(null)
		print("te lo echaste")
		return
	var distance = self.position.distance_to(navigation_component.get_target().position)
	if distance > 32:
		navigation_component.set_target(navigation_component.get_target())
		set_state(STATE.PURSUING)
		


func command_old(pos: Vector2):
	navigation_component.set_target(pos)
	set_state(STATE.MOVING)

func command(amigo: Node2D):
	navigation_component.set_target(amigo)
	if not amigo or is_instance_of(amigo, TileMap):
		set_state(STATE.MOVING)
	elif is_instance_of(amigo, Unit):
		if not amigo.is_owner(player_id):
			set_state(STATE.PURSUING)
		
	elif is_instance_of(amigo, uMaterial):
		print("unit is moving to gather")
		current_resource_node = navigation_component.get_target()
		set_state(STATE.MOVING_TO_GATHER)
	elif is_instance_of(amigo, Building):
		if amigo.is_owner(player_id):
			set_state(STATE.STORING)
		else:
			set_state(STATE.PURSUING)


func set_state(new_state: STATE):
	previous_state = state
	state = new_state


func get_unit_group():
	return unit_group

func interact(to: Node2D):
	if is_instance_of(to, Unit):
		to.receive(self)
	elif is_instance_of(to, uMaterial):
		to.get_damage(self)
		Debug.dprint("Material attacked")
	elif is_instance_of(to, MainBuilding):
		if to.is_owner(player_id):
			to.receive_from(self)
		else:
			to.receive_damage(self)

func subtract_material(qtt:int):
	material_count -= qtt
	

func receive(from: Node):
	if is_instance_of(from, Unit):
		health.get_damage(from)
		print("unit receive damage")
	elif is_instance_of(from, uMaterial):
		self.material_count = min(self.material_count+self.atk, RESOURCE_MAX)
		print("unit received material. actual: ", self.material_count)

func get_current_material():
	return [material_count, material_type]

@rpc("any_peer", "call_local")
func initialize(pos: Vector2, id: int):
	position = pos
	player_id = id
	set_multiplayer_authority(player_id)
	modulate = Game.get_player(player_id).get_color()
	

func _ready():
	cooldown = Timer.new()
	cooldown.set_one_shot(false)
	cooldown.set_wait_time(cooldown_time)
	cooldown.timeout.connect(_on_timeout)
	add_child(cooldown)
	cooldown.start()
	if not is_multiplayer_authority():
		return
	
func _on_timeout():
	can_attack = true


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
			$Label.text = "IDLE"
		STATE.MOVING:
			state_move_process()
			state_move_transition()
			$Label.text = "MOVING"
		STATE.MOVING_TO_GATHER:
			state_moving_to_gather_process()
			state_moving_to_gather_transition()
			$Label.text = "MOVING_TO_GATHER"
		STATE.GATHERING:
			state_gathering_process()
			state_gathering_transition()
			$Label.text = "GATHERING"
		STATE.STORING:
			state_storing_process()
			state_storing_transition()
			$Label.text = "STORING"
		STATE.PURSUING:
			state_pursuing_process()
			state_pursuing_transition()
			$Label.text = "PURSUING"
		STATE.FIGHTING:
			state_fighting_process()
			state_fighting_transition()
			$Label.text = "FIGHTING"
