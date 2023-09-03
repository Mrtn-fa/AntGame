class_name Unit extends CharacterBody2D

var speed = 50
var target = Vector2()


@export var player_id: int

func _ready():
	randomize()
	
func set_target(new_target):
	target = new_target
	print(target)


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
	velocity = position.direction_to(target) * speed
	if position.distance_to(target) > 20:
		move_and_slide()
	
func _process(delta):
	position += Vector2(randi_range(-10, 10), randi_range(-10, 10)) * delta
