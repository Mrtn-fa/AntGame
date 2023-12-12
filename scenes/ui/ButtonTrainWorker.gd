extends Button

var target = null
var cost = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Label.text = cost
	
func _on_pressed():
	if target != null:
		target.train()
