extends Control



func _on_jugar_pressed():
	get_tree().change_scene_to_file("res://scenes/lobby.tscn")


func _on_creditos_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/credits_menu.tscn")


func _on_salir_pressed():
	get_tree().quit()


func _on_controles_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/control_menu.tscn")
