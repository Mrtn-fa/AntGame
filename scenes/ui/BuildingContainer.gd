extends Control

@onready var button_train_worker = $ButtonTrainWorker
@onready var button_build_satellite = $ButtonBuildSatellite
@onready var button_build_barracks = $ButtonBuildBarracks

# Called when the node enters the scene tree for the first time.
func _ready():
	Util.building_container = self

func show_building_ui():
	button_build_satellite.visible = true
	button_build_barracks.visible = true
	
func hide_building_ui():
	button_build_satellite.visible = false
	button_build_barracks.visible = false

func show_main_building(building):
	button_train_worker.visible = true
	button_train_worker.target = building
	button_train_worker.cost = str(building.unit_cost) + " " + building.unit_material
	hide_building_ui()

func hide_all():
	# disconnect main button
	button_train_worker.visible = false
	button_train_worker.target = null
	show_building_ui()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
