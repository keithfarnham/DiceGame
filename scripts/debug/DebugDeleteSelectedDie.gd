extends Button

#@onready var diceBag = get_tree().get_nodes_in_group("DiceBag")[0] as DiceBag

func _pressed():
	#TODO this
	print(get_tree_string())
	#diceBag.remove_selected_die()
