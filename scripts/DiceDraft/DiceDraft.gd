extends Control

@onready var diceGrid = $DiceGrid as DiceGrid

var scoreDraftCount = 0
var rewardDraftCount = 0

func _ready():
	DiceData.generate_starting_dice()
	scoreDraftCount = 2
	rewardDraftCount = 2
	setup_draft_score()
	setup_draft_reward()
	$TextControl/ScoreDiceChoiceValue.text = str(scoreDraftCount)
	$TextControl/RewardDiceChoiceValue.text = str(rewardDraftCount)
	diceGrid.populate_grid()
	
func setup_draft_score():
	var diceToAdd : Array[Die] = []
	match PlayerDice.ChosenClass:
		PlayerClass.ClassChoice.StandardGambler:
			diceToAdd.append(DiceData.random_score_die(DiceData.DieRarity.common, 6))
			diceToAdd.append(DiceData.random_score_die(DiceData.DieRarity.common, 6))
			diceToAdd.append(DiceData.random_score_die(DiceData.DieRarity.common, 6))
		PlayerClass.ClassChoice.DungeonMaster:
			diceToAdd.append(DiceData.random_score_die(DiceData.DieRarity.common, 20))
			diceToAdd.append(DiceData.random_score_die(DiceData.DieRarity.common, 20))
			diceToAdd.append(DiceData.random_score_die(DiceData.DieRarity.common, 20))
		PlayerClass.ClassChoice.DiceLover:
			diceToAdd = DiceData.generate_random_draft_score_dice(3)
		_:
			diceToAdd = DiceData.generate_random_draft_score_dice(3)
	PlayerDice.DraftScoreDice = diceToAdd

func setup_draft_reward():
	var diceToAdd : Array[Die] = []
	match PlayerDice.ChosenClass:
		PlayerClass.ClassChoice.StandardGambler:
			diceToAdd.append(DiceData.random_reward_die(DiceData.DieRarity.common, 6))
			diceToAdd.append(DiceData.random_reward_die(DiceData.DieRarity.common, 6))
		PlayerClass.ClassChoice.DungeonMaster:
			diceToAdd.append(DiceData.random_reward_die(DiceData.DieRarity.common, 20))
			diceToAdd.append(DiceData.random_reward_die(DiceData.DieRarity.common, 20))
		PlayerClass.ClassChoice.DiceLover:
			diceToAdd = DiceData.generate_random_draft_reward_dice(2)
		_:
			diceToAdd = DiceData.generate_random_draft_reward_dice(2)
	PlayerDice.DraftRewardDice = diceToAdd

func _on_choose_die_pressed():
	var dieToAdd : Die
	match diceGrid.currentTab:
		DiceGrid.GridTabs.score:
			dieToAdd = PlayerDice.DraftScoreDice[diceGrid.selectedDie]
			#DraftScoreDice.remove_at(selectedDie)
			scoreDraftCount -= 1
			$TextControl/ScoreDiceChoiceValue.text = str(scoreDraftCount)
		DiceGrid.GridTabs.reward:
			dieToAdd = PlayerDice.DraftRewardDice[diceGrid.selectedDie]
			#DraftRewardDice.remove_at(selectedDie)
			rewardDraftCount -= 1
			$TextControl/RewardDiceChoiceValue.text = str(rewardDraftCount)
	
	PlayerDice.add_die(dieToAdd)
	diceGrid.refresh_face_grid_and_hide_die()
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
		diceGrid.set_tab(DiceGrid.GridTabs.reward)
	elif rewardDraftCount == 0 and scoreDraftCount > 0:
		$"DiceGrid/DiceTabs/Reward Dice".visible = false
		diceGrid.set_tab(DiceGrid.GridTabs.score)

func _on_continue_pressed():
	get_tree().change_scene_to_file("res://scenes/RollReward.tscn")
