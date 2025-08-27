extends Button

func _pressed():
	print("Changing Scene to ChooseDice")
	get_tree().change_scene_to_file("res://scenes/ChooseDice.tscn")
