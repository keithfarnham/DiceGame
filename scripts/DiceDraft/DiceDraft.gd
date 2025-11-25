extends Control

#TODO genericize the DiceGrid class to support the draft grid so there's less shared code between the two
@onready var scoreDiceGrid = $DiceGrid/DiceGridContainer/Panel/AspectRatioContainer/HBoxContainer/ScoreDiceScrollContainer/ScoreDiceGrid as GridContainer
@onready var rewardDiceGrid = $DiceGrid/DiceGridContainer/Panel/AspectRatioContainer/HBoxContainer/RewardDiceScrollContainer/RewardDiceGrid as GridContainer
@onready var faceGrid = $DiceGrid/DiceGridContainer/Panel/AspectRatioContainer/HBoxContainer/FaceScrollContainer/FaceGrid as GridContainer

var DieUIScene = preload("res://scenes/DieUIScene.tscn")
var DieFaceUIScene = preload("res://scenes/DiceFaceUIScene.tscn")

var DraftScoreDice : Array[Die]
var DraftRewardDice : Array[Die]

var scoreDraftCount = 0
var rewardDraftCount = 0

enum GridTabs {
	score,
	reward
}

var selectedDie := -1 #index of selected die in current grid tab
var currentTab : GridTabs

func _ready():
	DiceData.generate_starting_dice()
	scoreDraftCount = 2
	rewardDraftCount = 2
	setup_draft_score()
	setup_draft_reward()
	$TextControl/ScoreDiceChoiceValue.text = str(scoreDraftCount)
	$TextControl/RewardDiceChoiceValue.text = str(rewardDraftCount)
	$"DiceGrid/DiceTabs/Score Dice".set_pressed_no_signal(true)
	
func setup_draft_score():
	var diceToGenerate = 3
	DraftScoreDice = DiceData.generate_draft_score_dice(diceToGenerate)
	add_dice(DraftScoreDice)

func setup_draft_reward():
	var diceToGenerate = 3
	DraftRewardDice = DiceData.generate_draft_reward_dice(diceToGenerate)
	add_dice(DraftRewardDice)

func add_die(die : Die, dieIndex : int):
	var diceGrid
	print("[DiceDraft] die type is " + str(DiceData.DiceType.keys()[die.type]))
	match die.type:
		DiceData.DiceType.reward:
			diceGrid = rewardDiceGrid
		DiceData.DiceType.score:
			diceGrid = scoreDiceGrid
	
	var newDieUIInstance = DieUIScene.instantiate() as DieUI
	newDieUIInstance.initialize(die, dieIndex)
	newDieUIInstance.dieSelected.connect(die_selected)
	diceGrid.add_child(newDieUIInstance)

func add_dice(dice : Array[Die]):
	for dieIndex in dice.size():
		var die = dice[dieIndex] as Die
		die.print()
		print("[DiceDraft] adding dice at index " + str(dieIndex) + " of type " + str(DiceData.DiceType.keys()[dice[dieIndex].type]))
		add_die(dice[dieIndex], dieIndex)

func die_selected(dieIndex : int):
	print("[DiceDraft] die_selected prev selected " + str(selectedDie) + " with die index " + str(dieIndex))
	if selectedDie == dieIndex and faceGrid.visible:
		#hide face UI and unfocus if reselecting the previously selected die
		selectedDie = -1
		faceGrid.visible = false
		$ChooseDie.text = "Select A Die"
		match currentTab:
			GridTabs.score:
				scoreDiceGrid.get_child(dieIndex).release_focus()
			GridTabs.reward:
				rewardDiceGrid.get_child(dieIndex).release_focus()
		return
	else:
		faceGrid.visible = true
	$ChooseDie.text = "Choose Selected Die"
	$ChooseDie.visible = true
	
	selectedDie = dieIndex
	clear_face_grid()
	var rewardTab = currentTab == GridTabs.reward
	for faceIndex in (DraftRewardDice[dieIndex].num_faces() if rewardTab else DraftScoreDice[dieIndex].num_faces()):
		var newFaceUIInstance = DieFaceUIScene.instantiate() as DieFaceUI
		var type = DraftRewardDice[dieIndex].faces[faceIndex].type \
			if rewardTab else DraftScoreDice[dieIndex].faces[faceIndex].type
		var value = DraftRewardDice[dieIndex].faces[faceIndex].value \
			if rewardTab else DraftScoreDice[dieIndex].faces[faceIndex].value
		var dieFace = DieFace.new(value, type)
		#var enableFocus = true if gridType == GridType.allDiceFaceChoice or gridType == GridType.faceChoice else false
		newFaceUIInstance.initialize(dieFace, faceIndex, false)
		#newFaceUIInstance.faceSelected.connect(face_selected)
		faceGrid.add_child(newFaceUIInstance)
		
		newFaceUIInstance.focus_mode = Control.FOCUS_NONE

func refresh_grids():
	clear_face_grid()
	remove_die(currentTab)
	#wait to clear the selectedDie value until after refresh so we have index of die to remove
	selectedDie = -1
	#add_dice(DraftScoreDice)
	#add_dice(DraftRewardDice)

func remove_die(tab : GridTabs):
	match tab:
		GridTabs.score:
			var child = scoreDiceGrid.get_child(selectedDie)
			child.visible = false
			#scoreDiceGrid.remove_child(child)
			#child.queue_free()
		GridTabs.reward:
			var child = rewardDiceGrid.get_child(selectedDie)
			child.visible = false
			#rewardDiceGrid.remove_child(child)
			#child.queue_free()

func clear_face_grid():
	for child in faceGrid.get_children():
		child.queue_free()
		faceGrid.remove_child(child)

func set_tab(newTab : GridTabs):
	currentTab = newTab
	print("[DiceDraft] set_tab to " + str(GridTabs.keys()[newTab]))
	clear_face_grid()
	selectedDie = -1
	match newTab:
		GridTabs.score:
			$ChooseDie.visible = false if scoreDraftCount == 0 else $ChooseDie.visible
			$"DiceGrid/DiceTabs/Reward Dice".set_pressed_no_signal(false)
			$DiceGrid/DiceGridContainer/Panel/AspectRatioContainer/HBoxContainer/RewardDiceScrollContainer.visible = false
			$DiceGrid/DiceGridContainer/Panel/AspectRatioContainer/HBoxContainer/ScoreDiceScrollContainer.visible = true
		GridTabs.reward:
			$ChooseDie.visible = false if rewardDraftCount == 0 else $ChooseDie.visible
			$"DiceGrid/DiceTabs/Score Dice".set_pressed_no_signal(false)
			$DiceGrid/DiceGridContainer/Panel/AspectRatioContainer/HBoxContainer/ScoreDiceScrollContainer.visible = false
			$DiceGrid/DiceGridContainer/Panel/AspectRatioContainer/HBoxContainer/RewardDiceScrollContainer.visible = true

func _on_score_dice_toggled(toggled_on):
	if toggled_on:
		set_tab(GridTabs.score)
		$ChooseDie.visible = true if scoreDraftCount > 0 else false
	else:
		$"DiceGrid/DiceTabs/Score Dice".set_pressed_no_signal(true)

func _on_reward_dice_toggled(toggled_on):
	if toggled_on:
		set_tab(GridTabs.reward)
		$ChooseDie.visible = true if rewardDraftCount > 0 else false
	else:
		$"DiceGrid/DiceTabs/Reward Dice".set_pressed_no_signal(true)

func _on_choose_die_pressed():
	var dieToAdd : Die
	match currentTab:
		GridTabs.score:
			dieToAdd = DraftScoreDice[selectedDie]
			#DraftScoreDice.remove_at(selectedDie)
			scoreDraftCount -= 1
			$TextControl/ScoreDiceChoiceValue.text = str(scoreDraftCount)
		GridTabs.reward:
			dieToAdd = DraftRewardDice[selectedDie]
			#DraftRewardDice.remove_at(selectedDie)
			rewardDraftCount -= 1
			$TextControl/RewardDiceChoiceValue.text = str(rewardDraftCount)
	
	PlayerDice.add_die(dieToAdd)
	refresh_grids()
	$ChooseDie.text = "Select A Die"
	
	if scoreDraftCount == 0 and rewardDraftCount == 0:
		$ChooseDie.visible = false
		$Continue.visible = true
		$DraftLabel.text = "All Dice Drafted"
	elif scoreDraftCount == 0 and rewardDraftCount > 0:
		$"DiceGrid/DiceTabs/Score Dice".visible = false
		set_tab(GridTabs.reward)
	elif rewardDraftCount == 0 and scoreDraftCount > 0:
		$"DiceGrid/DiceTabs/Reward Dice".visible = false
		set_tab(GridTabs.score)

func _on_continue_pressed():
	get_tree().change_scene_to_file("res://scenes/RollReward.tscn")
