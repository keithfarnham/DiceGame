extends Button

func _pressed():
	print("Switching Scene to ChooseReward")
	get_tree().change_scene_to_file("res://scenes/ChooseReward.tscn")
