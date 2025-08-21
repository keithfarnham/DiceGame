extends Button

signal debug_print

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _pressed():
	print("PlayerDice:")
	debug_print.emit()
	PlayerDice.debug_print_dice_array()
	#print("DiceGrid:")
	#var diceGrid = get_tree().get_first_node_in_group("SceneRoot").get_node("DiceUI").get_node("DiceGridScroll").get_node("DiceGrid") as DiceGrid
	
