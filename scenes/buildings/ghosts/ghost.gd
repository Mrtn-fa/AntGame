class_name Ghost extends Building


var build_level = 0
var build_max = 10
var real_building = ""
var my_unit = null
var frame_my_unit_was_set = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	$TimeRemaining.max_value = build_max


func build_real():
	Util.main.spawn_building(global_position, real_building)
	Util.main.despawn_node(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$TimeRemaining.value = build_level
	
	if build_level >= build_max:
		build_real()


func receive_from(unit: Unit):
	$TimeRemaining.visible = true
	
	var modifier = 1
	
	if Game.get_current_player().role == Game.Role.TERMITES:
		var time_diff = Engine.get_process_frames() - frame_my_unit_was_set
		
		if not is_instance_valid(my_unit) or my_unit == null or time_diff > 1000:
			my_unit = unit
			frame_my_unit_was_set = Engine.get_process_frames()
		
		if my_unit != unit:
			modifier = 0
		
	build_level += unit.build_speed * modifier


@rpc("any_peer", "call_local")
func rip():
	self.queue_free()
