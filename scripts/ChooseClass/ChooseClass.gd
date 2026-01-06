extends Control

var chosenClass : PlayerClass.ClassChoice

func _class_pressed(classSelected : PlayerClass.ClassChoice):
	$Continue.text = "Start with chosen class"
	$Continue.disabled = false
	$ClassInfo/ClassName.text = PlayerClass.get_class_name(classSelected)
	$ClassInfo/ClassFeatures.text = PlayerClass.get_class_features(classSelected)
	chosenClass = classSelected

func _on_standard_pressed():
	_class_pressed(PlayerClass.ClassChoice.StandardGambler)

func _on_dungeon_master_pressed():
	_class_pressed(PlayerClass.ClassChoice.DungeonMaster)

func _on_dice_lover_pressed():
	_class_pressed(PlayerClass.ClassChoice.DiceLover)

func _on_continue_pressed():
	PlayerDice.ChosenClass = chosenClass
	get_tree().change_scene_to_file("res://scenes/DiceDraft.tscn")
