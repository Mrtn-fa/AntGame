class_name Ghost extends Building


var build_level = 0
var build_max = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	$TimeRemaining.max_value = build_max


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$TimeRemaining.value = build_level
