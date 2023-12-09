extends Label

# Called when the node enters the scene tree for the first time.
func _ready():
	text = str(0)
		
func _process(_delta: float) -> void:
	var player = Game.get_current_player().player_node
	Debug.dprint(player.sugar)
	text = str(player.sugar)
