extends Control

@onready var rewardGrid = $RewardGrid as GridContainer
@onready var chooseRewardButton = $ChooseReward/ChooseRewardButton as Button
@onready var chooseRewardConfirm = $ChooseReward/ChooseRewardConfirm as ConfirmationDialog
@onready var rewardHandlerUI = $RewardHandlerUI as Control
@onready var diceGrid = $RewardHandlerUI/DiceGrid as DiceGrid
@onready var continueButton = $Continue as Button

var DieFaceUIScene = preload("res://scenes/DiceFaceUIScene.tscn")
var ChosenReward : DieFaceData.RewardType

func _ready():
	#populate grid with PlayerDice.RewardStakes faces
	for faceIndex in PlayerDice.RewardStakes.size():
		var newFaceUIInstance = DieFaceUIScene.instantiate() as DieFaceUI
		var dieFace = DieFace.new(PlayerDice.RewardStakes[faceIndex].value, PlayerDice.RewardStakes[faceIndex].type)
		var enableFocus = true
		newFaceUIInstance.initialize(dieFace, faceIndex, enableFocus)
		newFaceUIInstance.faceSelected.connect(_on_pressed)
		rewardGrid.add_child(newFaceUIInstance)

func handle_rewards(chosenReward : DieFaceData.RewardType):
	var rewardText = $Continue/ContinueLabel as RichTextLabel
	match chosenReward:
		DieFaceData.RewardType.money:
			#TODO make this variable based on value rolled or level
			var amountToAdd = 10
			PlayerDice.Money += amountToAdd
			rewardText.text = "+" + str(amountToAdd) + " Money Added"
			continueButton.visible = true
		DieFaceData.RewardType.addDie:
			var newDie = DiceData.make_a_die(6)
			PlayerDice.add_die(newDie)
			rewardText.text = "Added a fresh D6!"
			continueButton.visible = true
		DieFaceData.RewardType.scoreReroll:
			PlayerDice.RerollScore += 1
			continueButton.visible = true
			rewardText.text = "Got a free Score Reroll Token!"
		DieFaceData.RewardType.rewardReroll:
			PlayerDice.RerollReward += 1
			continueButton.visible = true
			rewardText.text = "Got a free Reward Reroll Token!"
		#DieFaceData.RewardType.upgradeDieValue:
		DieFaceData.RewardType.addRemoveFace:
			#TODO switching between Score and Reward tabs is busted - face grid only shows score dice
			rewardHandlerUI.visible = true
			$RewardHandlerUI/addRemoveFace.visible = true
			diceGrid.visible = true
			diceGrid.set_type(DiceGrid.GridType.allDiceFaceChoice)
		DieFaceData.RewardType.plusMinusFaceValue:
			rewardHandlerUI.visible = true
			$RewardHandlerUI/plusMinusFaceValue.visible = true
			diceGrid.visible = true
			diceGrid.set_type(DiceGrid.GridType.faceChoice)
		DieFaceData.RewardType.duplicateScoreDie:
			rewardHandlerUI.visible = true
			$RewardHandlerUI/duplicateDie.visible = true
			diceGrid.visible = true
			diceGrid.currentTab = DiceGrid.GridTabs.score
			diceGrid.set_type(DiceGrid.GridType.dieChoice)

func _on_pressed(rewardIndex : int):
	print("[RewardChoice] face pressed index " + str(rewardIndex) + " selected reward type " + str(DieFaceData.RewardType.keys()[PlayerDice.RewardStakes[rewardIndex].value]))
	if chooseRewardButton.visible == false:
		chooseRewardButton.visible = true
	ChosenReward = PlayerDice.RewardStakes[rewardIndex].value as DieFaceData.RewardType

func _on_choose_die_button_pressed():
	chooseRewardButton.visible = false
	chooseRewardConfirm.visible = true

func _on_choose_die_confirm_confirmed():
	print("[RewardChoice] chosen reward is " + str(DieFaceData.RewardType.keys()[ChosenReward]))
	rewardGrid.visible = false
	handle_rewards(ChosenReward)

func _on_choose_die_confirm_canceled():
	chooseRewardConfirm.visible = false
	chooseRewardButton.visible = true

func _on_continue_pressed():
	#TODO this will end up going to a shop phase
	get_tree().change_scene_to_file("res://scenes/RollReward.tscn")
