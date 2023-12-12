class_name Sugar extends uMaterial

func get_damage(from: Unit):
	super.get_damage(from)
	from.material_type = 'Sugar'
	
