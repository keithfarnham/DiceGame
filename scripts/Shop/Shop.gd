extends Node

class_name Shop

@onready var diceGrid = $RewardHandlerUI/DiceGrid as DiceGrid
@onready var rewardHandlerUI = $RewardHandlerUI as RewardHandler

signal shop_closed

enum ShopOptions {
	PLUS_MAX_MOVES,
	ADD_FACE,
	REMOVE_FACE,
	
}

func _ready():
	#TODO DEBUG ONLY remove after shop is setup fully
	if PlayerDice.ScoreDice.is_empty():
		DiceData.generate_starting_dice()
		PlayerDice.Money = 50
	
	diceGrid.visible = true
	diceGrid.set_type(DiceGrid.GridType.allDiceChoice)
	update_shop()

func update_shop():
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
	_handle_shop_option_selected($ShopControl/ShopOptions/AddFace)
	$ShopControl.visible = false
	$RewardHandlerUI/addFace.visible = true #TODO might want to do the button visible stuff in the reward handler set_reward_type() call
	rewardHandlerUI.set_reward_type(RewardHandler.RewardHandlerType.SHOP, ShopOptions.ADD_FACE)
	diceGrid.set_type(DiceGrid.GridType.allDiceChoice)

func _on_remove_face_pressed():
	_handle_shop_option_selected($ShopControl/ShopOptions/RemoveFace)
	$ShopControl.visible = false
	$RewardHandlerUI/removeFace.visible = true
	rewardHandlerUI.set_reward_type(RewardHandler.RewardHandlerType.SHOP, ShopOptions.REMOVE_FACE)
	diceGrid.set_type(DiceGrid.GridType.allDiceFaceChoice)

func _on_plus_max_moves_pressed():
	_handle_shop_option_selected($ShopControl/ShopOptions/PlusMaxMoves)
	BoardData.maxMoves += 1
	$EventText.text = "Max moves increased by 1"

func _handle_shop_option_selected(buttonNode):
	buttonNode.timesBought += 1
	if buttonNode.timesBought >= buttonNode.maxTimesBought:
		buttonNode.disabled = true
	PlayerDice.Money -= buttonNode.cost
	update_shop()

func _on_leave_shop_pressed():
	shop_closed.emit()

func _on_continue_pressed():
	diceGrid.mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_ENABLED
	diceGrid.mouse_filter = Control.MOUSE_FILTER_PASS
	$Continue.visible = false
	$ShopControl.visible = true
	$EventText.text = ""
	diceGrid.set_type(DiceGrid.GridType.allDiceChoice)
