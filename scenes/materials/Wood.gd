class_name Wood extends uMaterial

#@onready var health = HealthComponent


func get_damage(from: Unit):
	super.get_damage(from)
	from.material_type = 'Wood'
	#Debug.dprint('tree damaged')
	
