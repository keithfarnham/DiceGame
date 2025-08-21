extends Button

func _pressed():
	#var faces : Array[DieFace]
	#PlayerDice.RewardStakes = faces
	print("Switching Scene to RollScore")
	get_tree().change_scene_to_file("res://scenes/RollScore.tscn")
