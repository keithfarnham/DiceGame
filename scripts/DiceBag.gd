extends Control

#TODO DiceBag isn't currently used
#this will likely end up being used to display your reward dice in the scoring sections and score dice in the reward section

@onready var diceGridLabel = $"../DiceGridLabel" as RichTextLabel
@onready var diceGrid = $"../DiceGrid" as DiceGrid
@onready var diceBagButton = $OpenDiceBag as Button

func update_text():
	if diceGrid.visible:
		if diceGrid.prevSelect >= 0:
			var dieUI = diceGrid.get_child(diceGrid.prevSelect) as DieUI
			#grabbing focus to prev selected die, see button node's theme overrides for color mod on focus/hover
			dieUI.grab_focus()
		diceBagButton.text = "Close Dice Bag"
	else:
		diceBagButton.text = "Open Dice Bag"


func _on_open_dice_bag_pressed():
	diceGridLabel.text = "Your Dice"
	diceGrid.visible = !diceGrid.visible
	update_text()
