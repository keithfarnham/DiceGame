extends Button

func _pressed():
	print("bruh")
	get_tree().change_scene_to_file("res://scenes/ChooseDice.tscn")
