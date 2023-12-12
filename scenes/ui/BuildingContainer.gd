extends Control

@onready var button_train_worker = $ButtonTrainWorker

# Called when the node enters the scene tree for the first time.
func _ready():
	Util.building_container = self

func show_main_building(building):
	button_train_worker.visible = true
	button_train_worker.target = building
	button_train_worker.cost = str(building.unit_cost) + " " + building.unit_material

func hide_all():
	# disconnect main button
	button_train_worker.visible = false
	button_train_worker.target = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
