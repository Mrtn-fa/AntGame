class_name Ghost extends Building


var build_level = 0
var build_max = 10
var real_building = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	$TimeRemaining.max_value = build_max


func build_real():
	Util.main.spawn_building(global_position, real_building)
	Util.main.despawn_node(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Debug.dprint(str(build_level) + "/" + str(build_max))
	$TimeRemaining.value = build_level
	
	if build_level >= build_max:
		build_real()


func receive_from(unit: Unit):
	build_level += unit.build_speed


@rpc("any_peer", "call_local")
func rip():
	self.queue_free()
