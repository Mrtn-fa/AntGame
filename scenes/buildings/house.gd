extends Node2D

@onready var sprite = $Sprite2D
@onready var nodo2d = $Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	var posicion = nodo2d.global_position
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		Debug.dprint(get_local_mouse_position())
#		Debug.dprint(to_local(event.position))
		if sprite.get_rect().has_point(get_local_mouse_position()):
			Util.main.spawn_unit(posicion, null)
			Debug.dprint("You clicked on this Sprite")
			Debug.dprint("La posición del nodo 2D es:")
			Debug.dprint(posicion)
