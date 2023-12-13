extends Button

var build_cost = 20
var build_material = "Wood"

func _process(delta):
	$Label.text = str(build_cost) + " " + str(build_material)

func _on_pressed():
	Util.building_controller.enter_build_mode("satellite", build_cost, build_material)
