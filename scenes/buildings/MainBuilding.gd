class_name MainBuilding extends Building

@onready var sprite = $Sprite2D
@onready var nodo2d = $Position1
@onready var position2 = $Position2
@onready var pos = 0
@onready var portrait_sprite = $Sprite2DPortrait

var satellites = []

func receive_from(unit: Unit):
	var player = Game.get_current_player().player_node
	player.add_material(unit)
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	Util.houses.append(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$TimeRemaining.text = "%s" % roundf($Timer.time_left)
	pass

func woah(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if sprite.get_rect().has_point(get_local_mouse_position()) and \
				$Timer.time_left==0 and \
				(player_id == multiplayer.get_unique_id()):
			$Timer.start()
			$TimeRemaining.show()

func create_unit():
	if sprite.get_rect().has_point(get_local_mouse_position()) and \
			$Timer.time_left==0 and \
			(player_id == multiplayer.get_unique_id()):
		$Timer.start()
		$TimeRemaining.show()

func _on_timer_timeout():
	if pos==0:
		var posicion = nodo2d.global_position
		$TimeRemaining.hide()
		Util.main.spawn_unit(posicion, null)
		pos += 1
	else:
		var posicion = position2.global_position
		$TimeRemaining.hide()
		Util.main.spawn_unit(posicion, null)
		pos -= 1
