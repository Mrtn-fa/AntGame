extends Button

var build_cost = 40
var build_material = "Wood"

func _process(delta):
	$Label.text = str(build_cost) + " " + str(build_material)

func _on_pressed():
	Util.building_controller.enter_build_mode("barracks", build_cost, build_material)
