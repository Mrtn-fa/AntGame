extends Label

#player_resources = get.node("../path/to/myscene.tscn").myglobalvar
var player_resources = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	text = str(player_resources)
		
func _process(_delta: float) -> void:
	text = str(player_resources)
