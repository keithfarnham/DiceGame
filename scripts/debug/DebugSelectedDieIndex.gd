extends RichTextLabel

#@onready var diceBag = get_tree().get_nodes_in_group("DiceBag")[0] as DiceBag

func _ready():
	#TODO rehook this up
	#diceBag.selectedDieUpdate.connect(die_selected)
	pass

func die_selected(selectedDieIndex : int):
	text = str(selectedDieIndex)
