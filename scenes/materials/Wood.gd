class_name Wood extends uMaterial

func get_damage(from: Unit):
	super.get_damage(from)
	from.material_type = 'Wood'
	Debug.dprint('tree damaged')
	
