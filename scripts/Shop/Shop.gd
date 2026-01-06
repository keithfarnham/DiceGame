extends Node

@onready var diceGrid = $RewardHandlerUI/DiceGrid as DiceGrid

signal shop_closed

func _ready():
	#TODO DEBUG ONLY remove after shop is setup fully
	if PlayerDice.ScoreDice.is_empty():
		DiceData.generate_starting_dice()
		PlayerDice.Money = 50
	
	diceGrid.visible = true
	diceGrid.set_type(DiceGrid.GridType.allDiceChoice)
	_update_shop()

func _update_shop():
	_update_current_money_text()
	#enable/disable buttons based on current money
	for button in $ShopControl/ShopOptions.get_children():
		if button.cost > PlayerDice.Money:
			button.disabled = true
		else:
			button.disabled = false

func _update_current_money_text():
	$ShopControl/CurrentMoney.text = "$" + str(PlayerDice.Money)

func _on_add_face_pressed():
	$ShopControl.visible = false
	$RewardHandlerUI.visible = true
	$RewardHandlerUI/addFace.visible = true
	diceGrid.set_type(DiceGrid.GridType.allDiceChoice)

func _on_remove_face_pressed():
	$ShopControl.visible = false
	$RewardHandlerUI.visible = true
	$RewardHandlerUI/removeFace.visible = true
	diceGrid.set_type(DiceGrid.GridType.allDiceFaceChoice)

func _on_plus_max_moves_pressed():
	var buttonNode = $ShopControl/ShopOptions/PlusMaxMoves
	buttonNode.timesBought += 1
	if buttonNode.timesBought >= buttonNode.maxTimesBought:
		buttonNode.disabled = true
	PlayerDice.Money -= buttonNode.cost
	BoardData.maxMoves += 1
	$EventText.text = "Max moves increased by 1"
	_update_shop()

func _on_leave_shop_pressed():
	shop_closed.emit()
