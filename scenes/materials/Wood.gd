class_name Wood extends uMaterial

func get_damage(from: Unit):
	super.get_damage(from)
	Debug.dprint('tree damaged')
	
