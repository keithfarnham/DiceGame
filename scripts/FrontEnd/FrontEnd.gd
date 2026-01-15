extends Control

func _ready():
	if !OS.is_debug_build():
		$DEBUG_TOGGLE.queue_free()
	_new_game()

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/ChooseClass.tscn")
	
func _new_game():
	PlayerDice.new_game()
	BoardData.reset_board_data()


func _on_debug_toggle_toggled(toggled_on):
	PlayerDice.DEBUG_Enabled = toggled_on
