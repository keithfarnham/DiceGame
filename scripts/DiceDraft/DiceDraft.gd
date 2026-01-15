extends Control

@onready var diceGrid = $DiceGrid as DiceGrid

var scoreDraftCount = 0
var rewardDraftCount = 0

func _ready():
	if !OS.is_debug_build() or !PlayerDice.DEBUG_Enabled:
		$"DEBUG AUTO DRAFT".queue_free()
	
	DiceData.generate_starting_dice()
	scoreDraftCount = 2
	rewardDraftCount = PlayerClass.get_class_num_reward_dice_draft(PlayerDice.ChosenClass)
	setup_draft_score()
	setup_draft_reward()
	$TextControl/ScoreDiceChoiceValue.text = str(scoreDraftCount)
	$TextControl/RewardDiceChoiceValue.text = str(rewardDraftCount)
	diceGrid.populate_grid()
	
func setup_draft_score():
	var diceToAdd : Array[Die] = []
	match PlayerDice.ChosenClass:
		PlayerClass.ClassChoice.StandardGambler:
			diceToAdd.append(DiceData.random_score_die(DiceData.DieRarity.COMMON, 6))
			diceToAdd.append(DiceData.random_score_die(DiceData.DieRarity.COMMON, 6))
			diceToAdd.append(DiceData.random_score_die(DiceData.DieRarity.COMMON, 6))
		PlayerClass.ClassChoice.DungeonMaster:
			diceToAdd.append(DiceData.random_score_die(DiceData.DieRarity.COMMON, 20))
			diceToAdd.append(DiceData.random_score_die(DiceData.DieRarity.COMMON, 20))
			diceToAdd.append(DiceData.random_score_die(DiceData.DieRarity.COMMON, 20))
		PlayerClass.ClassChoice.DiceLover:
			diceToAdd = DiceData.generate_random_draft_score_dice(3)
		_:
			diceToAdd = DiceData.generate_random_draft_score_dice(3)
	PlayerDice.DraftScoreDice = diceToAdd

func setup_draft_reward():
	var diceToAdd : Array[Die] = []
	match PlayerDice.ChosenClass:
		PlayerClass.ClassChoice.StandardGambler:
			diceToAdd.append(DiceData.random_reward_die(DiceData.DieRarity.COMMON, 6))
			diceToAdd.append(DiceData.random_reward_die(DiceData.DieRarity.COMMON, 6))
		PlayerClass.ClassChoice.DungeonMaster:
			diceToAdd.append(DiceData.random_reward_die(DiceData.DieRarity.COMMON, 20))
			diceToAdd.append(DiceData.random_reward_die(DiceData.DieRarity.COMMON, 20))
		PlayerClass.ClassChoice.DiceLover:
			diceToAdd = DiceData.generate_random_draft_reward_dice(2)
		PlayerClass.ClassChoice.DEBUG_REWARD_CLASS:
			diceToAdd = DiceData.DEBUG_ALL_REWARDS()
		_:
			diceToAdd = DiceData.generate_random_draft_reward_dice(2)
	PlayerDice.DraftRewardDice = diceToAdd

func _on_choose_die_pressed():
	var dieToAdd : Die
	match diceGrid.currentTab:
		DiceGrid.GridTabs.SCORE:
			dieToAdd = PlayerDice.DraftScoreDice[diceGrid.selectedDie]
			#DraftScoreDice.remove_at(selectedDie)
			scoreDraftCount -= 1
			$TextControl/ScoreDiceChoiceValue.text = str(scoreDraftCount)
		DiceGrid.GridTabs.REWARD:
			dieToAdd = PlayerDice.DraftRewardDice[diceGrid.selectedDie]
			#DraftRewardDice.remove_at(selectedDie)
			rewardDraftCount -= 1
			$TextControl/RewardDiceChoiceValue.text = str(rewardDraftCount)
	
	PlayerDice.add_die(dieToAdd)
	diceGrid.draft_die_selected()
	$ChooseDie.text = "Select a Die"
	$ChooseDie.disabled = true
	
	if scoreDraftCount == 0 and rewardDraftCount == 0:
		$ChooseDie.visible = false
		$Continue.visible = true
		$DraftLabel.text = "All Dice Drafted"
		$"DiceGrid/DiceTabs/Score Dice".visible = false
		$"DiceGrid/DiceTabs/Reward Dice".visible = false
	elif scoreDraftCount == 0 and rewardDraftCount > 0:
		$"DiceGrid/DiceTabs/Score Dice".visible = false
		diceGrid.set_tab(DiceGrid.GridTabs.REWARD)
	elif rewardDraftCount == 0 and scoreDraftCount > 0:
		$"DiceGrid/DiceTabs/Reward Dice".visible = false
		diceGrid.set_tab(DiceGrid.GridTabs.SCORE)

func _on_continue_pressed():
	get_tree().change_scene_to_file("res://scenes/RollReward.tscn")


#TODO REMOVE DEBUG ONLY
func _on_debug_auto_draft_pressed():
	for dieIndex in scoreDraftCount:
		PlayerDice.add_die(PlayerDice.DraftScoreDice[dieIndex])
	for dieIndex in rewardDraftCount:
		PlayerDice.add_die(PlayerDice.DraftRewardDice[dieIndex])
	$Continue.visible = true
	$ChooseDie.visible = false
	$"DEBUG AUTO DRAFT".disabled = true
