extends Button

#@onready var diceBag = get_tree().get_nodes_in_group("DiceBag")[0] as DiceBag

func _pressed():
	print(get_tree_string())
	#PlayerDice.remove_die()
	#TODO remove call to diceBag, either replace with contents of remove_all_dice() or make that func accessible from a more global place
	#PlayerDice.remove_all_dice()
