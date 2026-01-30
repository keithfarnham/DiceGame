extends Control

@onready var rewardGrid = $RewardGrid as GridContainer
@onready var chooseRewardButton = $ChooseReward/ChooseRewardButton as Button
@onready var chooseRewardConfirm = $ChooseReward/ChooseRewardConfirm as ConfirmationDialog
@onready var rewardHandlerUI = $RewardHandlerUI as RewardHandler
@onready var diceGrid = $RewardHandlerUI/DiceGrid as DiceGrid
@onready var continueButton = $Continue as Button

var DieFaceUIScene = preload("res://scenes/DiceFaceUIScene.tscn")
var ChosenReward : DieFaceData.RewardType

func _ready():
	#populate grid with PlayerDice.RewardStakes faces
	for faceIndex in range(PlayerDice.RewardStakes.size()):
		var newFaceUIInstance = DieFaceUIScene.instantiate() as DieFaceUI
		var dieFace = DieFace.new(PlayerDice.RewardStakes[faceIndex].value, PlayerDice.RewardStakes[faceIndex].type)
		var enableFocus = true
		newFaceUIInstance.initialize(dieFace, faceIndex, enableFocus)
		newFaceUIInstance.faceSelected.connect(_on_pressed)
		rewardGrid.add_child(newFaceUIInstance)

func handle_rewards(chosenReward : DieFaceData.RewardType):
	var eventText = $EventText as RichTextLabel
	eventText.visible = true
	match chosenReward:
		DieFaceData.RewardType.MONEY:
			#TODO make this variable based on value rolled or level
			var amountToAdd = 10
			PlayerDice.Money += amountToAdd
			eventText.text = "+" + str(amountToAdd) + " Money Added"
			continueButton.visible = true
		DieFaceData.RewardType.ADD_DIE:
			var newDie = DiceData.make_a_die(6)
			PlayerDice.add_die(newDie)
			eventText.text = "Added a fresh D6!"
			continueButton.visible = true
		#DieFaceData.RewardType.scoreReroll:
			#PlayerDice.RerollScore += 1
			#continueButton.visible = true
			#eventText.text = "Got a free Score Reroll Token!"
		#DieFaceData.RewardType.rewardReroll:
			#PlayerDice.RerollReward += 1
			#continueButton.visible = true
			#eventText.text = "Got a free Reward Reroll Token!"
		#DieFaceData.RewardType.upgradeDieValue:
		DieFaceData.RewardType.ADD_REMOVE_FACE:
			eventText.text = "Choose a Die to add or remove a face"
			rewardHandlerUI.set_reward_type(RewardHandler.RewardHandlerType.REWARD_DIE, DieFaceData.RewardType.ADD_REMOVE_FACE)
		DieFaceData.RewardType.PLUS_MINUS_FACE:
			eventText.text = "Choose a Die Face to +1 or -1 value"
			rewardHandlerUI.set_reward_type(RewardHandler.RewardHandlerType.REWARD_DIE, DieFaceData.RewardType.PLUS_MINUS_FACE)
		DieFaceData.RewardType.DUPE_SCORE_DIE:
			eventText.text = "Choose a score die to duplicate"
			rewardHandlerUI.set_reward_type(RewardHandler.RewardHandlerType.REWARD_DIE, DieFaceData.RewardType.DUPE_SCORE_DIE)
		DieFaceData.RewardType.LOWEST_PLUS_3:
			eventText.text = "Choose a Die to give +3 to its [color=#beb500]lowest[/color] value face"
			rewardHandlerUI.set_reward_type(RewardHandler.RewardHandlerType.REWARD_DIE, DieFaceData.RewardType.LOWEST_PLUS_3)
		DieFaceData.RewardType.REPLACE_LOW_W_HIGH:
			eventText.text = "Choose a Die to replace the [color=#beb500]lowest[/color] value with its [color=#00ffff]highest[/color] value face"
			rewardHandlerUI.set_reward_type(RewardHandler.RewardHandlerType.REWARD_DIE, DieFaceData.RewardType.REPLACE_LOW_W_HIGH)
		DieFaceData.RewardType.COPY_PASTE:
			eventText.text = "Choose a die face to copy and another to paste over and replace"
			rewardHandlerUI.set_reward_type(RewardHandler.RewardHandlerType.REWARD_DIE, DieFaceData.RewardType.COPY_PASTE)

func _on_pressed(rewardIndex : int):
	Log.print("[RewardChoice] face pressed index " + str(rewardIndex) + " selected reward type " + str(DieFaceData.RewardType.keys()[PlayerDice.RewardStakes[rewardIndex].value]))
	if chooseRewardButton.visible == false:
		chooseRewardButton.visible = true
	ChosenReward = PlayerDice.RewardStakes[rewardIndex].value as DieFaceData.RewardType

func _on_choose_die_button_pressed():
	chooseRewardButton.visible = false
	chooseRewardConfirm.visible = true

func _on_choose_die_confirm_confirmed():
	Log.print("[RewardChoice] chosen reward is " + str(DieFaceData.RewardType.keys()[ChosenReward]))
	rewardGrid.visible = false
	handle_rewards(ChosenReward)

func _on_choose_die_confirm_canceled():
	chooseRewardConfirm.visible = false
	chooseRewardButton.visible = true

func _on_continue_pressed():
	get_tree().change_scene_to_file("res://scenes/MoveBoard.tscn")
