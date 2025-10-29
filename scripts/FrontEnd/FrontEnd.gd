extends Control

func _on_start_pressed():
	print("[FrontEnd] Switching Scene to RollReward")
	get_tree().change_scene_to_file("res://scenes/RollReward.tscn")
