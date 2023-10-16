class_name MainBuilding extends Node2D

@onready var sprite = $AntHill
@onready var nodo2d = $Position1
@onready var position2 = $Position2
@onready var pos = 0


func receive_from(unit: Unit):
	#var player = get_player()
	#player.add_material(unit)
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$TimeRemaining.text = "%s" % roundf($Timer.time_left)
#	Debug.dprint($Timer.time_left)
	pass

func _input(event):
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
#		Debug.dprint(get_local_mouse_position())
#		Debug.dprint(to_local(event.position))
		if sprite.get_rect().has_point(get_local_mouse_position()) and $Timer.time_left==0:
			$Timer.start()
			$TimeRemaining.show()
#			Util.main.spawn_unit(posicion, null)
#			Debug.dprint("You clicked on this Sprite")
#			Debug.dprint("La posición del nodo 2D es:")
#			Debug.dprint(posicion)

func _on_timer_timeout():
	if pos==0:
		var posicion = nodo2d.global_position
#		Debug.dprint("timer timeout")
#		Debug.dprint(posicion)
		$TimeRemaining.hide()
		Util.main.spawn_unit(posicion, null)
		pos += 1
	else:
		var posicion = position2.global_position
#		Debug.dprint(posicion)
		$TimeRemaining.hide()
		Util.main.spawn_unit(posicion, null)
		pos -= 1
