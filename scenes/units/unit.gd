class_name Unit extends CharacterBody2D

var speed = 50
var target = Vector2()
var previous_position = Vector2.ZERO
var atk = 2
var material_count = 0

@export var player_id: int
@export var Mat: uMaterial
@export var health: HealthComponent

func _ready():
	randomize()
	
func set_target(new_target):
	target = new_target


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
func initialize(pos, id):
	position = pos
	player_id = id
	set_target(pos)
	set_multiplayer_authority(player_id)
	if not is_multiplayer_authority():
		pass # process_mode = Node.PROCESS_MODE_DISABLED
	
	modulate = Game.get_player(player_id).get_color()

# TODO: method "handle_target"
# Target	-> Enemy Unit: Attack
# 			-> Building: ???
#			-> Resource: Gather
#			-> Nothing: move
func _physics_process(delta):
	previous_position = position
	if is_multiplayer_authority():
		velocity = position.direction_to(target) * speed
		if velocity.x < 0:
			$Sprite2D.flip_h = true
		elif velocity.x > 0:
			$Sprite2D.flip_h = false
		if position.distance_to(target) > 20:
			move_and_slide()
	
func _process(delta):
	pass
	#$Sprite2D.position += Vector2(randi_range(-10, 10), randi_range(-10, 10)) * delta
	#$Sprite2D.position.x = clamp($Sprite2D.position.x, -6, 6)
	#$Sprite2D.position.y = clamp($Sprite2D.position.y, -6, 6)
