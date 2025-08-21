extends Button

@onready var diceGridLabel = $"../DiceGridLabel" as RichTextLabel
@onready var diceUI = $"../DiceUI" as Control
#@onready var diceUI = $"../DiceGridControl" as Control
#@onready var diceBag = get_tree().get_nodes_in_group("DiceBag")[0] as DiceBag
@onready var diceGrid = $"../DiceUI/DiceGridScroll/DiceGrid" as GridContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	update_text()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _pressed():
	diceGridLabel.text = "Your Dice"
	diceUI.visible = !diceUI.visible
	update_text()

func update_text():
	if diceUI.visible:
		if diceGrid.prevSelect >= 0:
			var dieUI = diceGrid.get_child(diceGrid.prevSelect) as DieUI
			#grabbing focus to prev selected die, see button node's theme overrides for color mod on focus/hover
			dieUI.grab_focus()
		text = "Close Dice Bag"
	else:
		text = "Open Dice Bag"
