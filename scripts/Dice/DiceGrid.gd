extends Control

class_name DiceGrid

@onready var scoreDiceGrid = $DiceGridContainer/Panel/AspectRatioContainer/HBoxContainer/ScoreDiceScrollContainer/ScoreDiceGrid as GridContainer
@onready var rewardDiceGrid = $DiceGridContainer/Panel/AspectRatioContainer/HBoxContainer/RewardDiceScrollContainer/RewardDiceGrid as GridContainer
@onready var faceGrid = $DiceGridContainer/Panel/AspectRatioContainer/HBoxContainer/FaceScrollContainer/FaceGrid as GridContainer

var DieUIScene = preload("res://scenes/DieUIScene.tscn")
var DieFaceUIScene = preload("res://scenes/DiceFaceUIScene.tscn")

signal faceSelected(faceIndex : int)
signal dieSelected(dieIndex : int)

@export var gridType : GridType

enum GridType {
	draft,
	scoreRoll,
	rewardRoll,
	rewardChoice,#below are the different reward choice types
		allDiceChoice, #for selecting a single die from all dice
		allDiceFaceChoice, #for selecting a single die face from all dice
		faceChoice, #for selecting a single face on a die
		dieChoice, #for selecting a single die from one tab
}

enum GridTabs {
	score,
	reward
}

enum SortType {
	type,
	numFaces
}

var selectedDie := -1 #index of selected die in current grid tab
var selectedFace := -1 #index of selected face in face grid for currently selected die tab
var currentTab : GridTabs

func _ready():
	pass
	#now calling populate_grid() from scene's base script to ensure the PlayerDice dice arrays (particularly the DraftDice arrays) are populated before doing add_dice
	#set_type(gridType)

func populate_grid():
	match gridType:
		GridType.draft:
			set_tab(GridTabs.score)
			$DiceTabs.visible = true
			add_dice(PlayerDice.DraftScoreDice)
			add_dice(PlayerDice.DraftRewardDice)
			faceGrid.focus_mode = Control.FOCUS_NONE
		GridType.scoreRoll:
			set_tab(GridTabs.score)
			add_dice(PlayerDice.ScoreDice)
		GridType.rewardRoll:
			set_tab(GridTabs.reward)
			add_dice(PlayerDice.RewardDice)
		GridType.allDiceChoice:
			$DiceTabs.visible = true
			add_dice(PlayerDice.ScoreDice)
			add_dice(PlayerDice.RewardDice)
			faceGrid.focus_mode = Control.FOCUS_NONE
		GridType.allDiceFaceChoice:
			$DiceTabs.visible = true
			add_dice(PlayerDice.ScoreDice)
			add_dice(PlayerDice.RewardDice)
		GridType.faceChoice:
			set_tab(GridTabs.score)
			add_dice(PlayerDice.ScoreDice)
			faceGrid.focus_mode = Control.FOCUS_CLICK
		GridType.dieChoice:
			faceGrid.focus_mode = Control.FOCUS_NONE
			match currentTab:
				DiceGrid.GridTabs.score:
					add_dice(PlayerDice.ScoreDice)
				DiceGrid.GridTabs.reward:
					add_dice(PlayerDice.RewardDice)

func set_type(newType : GridType):
	gridType = newType
	print("[DiceGrid] Grid type set to " + str(GridType.keys()[newType]))
	populate_grid()

func set_tab(newTab : GridTabs):
	currentTab = newTab
	print("[DiceGrid] set_tab to " + str(GridTabs.keys()[newTab]))
	clear_face_grid()
	selectedDie = -1
	selectedFace = -1
	match newTab:
		GridTabs.score:
			$"DiceTabs/Score Dice".set_pressed_no_signal(true)
			$"DiceTabs/Reward Dice".set_pressed_no_signal(false)
			$DiceGridContainer/Panel/AspectRatioContainer/HBoxContainer/RewardDiceScrollContainer.visible = false
			$DiceGridContainer/Panel/AspectRatioContainer/HBoxContainer/ScoreDiceScrollContainer.visible = true
		GridTabs.reward:
			$"DiceTabs/Reward Dice".set_pressed_no_signal(true)
			$"DiceTabs/Score Dice".set_pressed_no_signal(false)
			$DiceGridContainer/Panel/AspectRatioContainer/HBoxContainer/ScoreDiceScrollContainer.visible = false
			$DiceGridContainer/Panel/AspectRatioContainer/HBoxContainer/RewardDiceScrollContainer.visible = true

func add_die(die : Die, dieIndex : int):
	var diceGrid
	print("[DiceGrid] die type is " + str(DiceData.DiceType.keys()[die.type]))
	match die.type:
		DiceData.DiceType.reward:
			diceGrid = rewardDiceGrid
		DiceData.DiceType.score:
			diceGrid = scoreDiceGrid
	#the newDieUIInstance needs to be added to the tree before I can assign child nodes their data
	#so I do the initialize() to setup the data in the DieUI class, then when add_child() is called 
	#the DieUI's _ready() will assign the data to the child nodes
	var newDieUIInstance = DieUIScene.instantiate() as DieUI
	newDieUIInstance.initialize(die, dieIndex)
	newDieUIInstance.dieSelected.connect(die_selected)
	diceGrid.add_child(newDieUIInstance)

func add_dice(dice : Array[Die]):
	for dieIndex in dice.size():
		print("[DiceGrid] adding dice at index " + str(dieIndex) + " of type " + str(DiceData.DiceType.keys()[dice[dieIndex].type]))
		add_die(dice[dieIndex], dieIndex)

func die_selected(dieIndex : int):
	dieSelected.emit(dieIndex)
	print("[DiceGrid] die_selected prev selected " + str(selectedDie) + " with die index " + str(dieIndex))
	var draftNode
	if gridType == GridType.draft:
		draftNode = get_tree().get_first_node_in_group("DiceDraft")
	if selectedDie == dieIndex and faceGrid.visible:
		#hide face UI and unfocus if reselecting the previously selected die
		selectedDie = -1
		faceGrid.visible = false
		if gridType == GridType.draft:
			draftNode.find_child("ChooseDie").text = "Select a Die"
			draftNode.find_child("ChooseDie").disabled = true
			draftNode.find_child("ChooseDie").focus_mode = Control.FOCUS_NONE
		match currentTab:
			GridTabs.score:
				scoreDiceGrid.get_child(dieIndex).release_focus()
			GridTabs.reward:
				rewardDiceGrid.get_child(dieIndex).release_focus()
		return
	else:
		faceGrid.visible = true
	
	if gridType == GridType.draft:
		draftNode.find_child("ChooseDie").text = "Choose Selected Die"
		draftNode.find_child("ChooseDie").disabled = false
		draftNode.find_child("ChooseDie").visible = true
		draftNode.find_child("ChooseDie").focus_mode = Control.FOCUS_CLICK
	
	selectedDie = dieIndex
	clear_face_grid()
	var rewardTab = currentTab == GridTabs.reward
	var scoreDice = PlayerDice.DraftScoreDice if gridType == GridType.draft else PlayerDice.ScoreDice
	var rewardDice = PlayerDice.DraftRewardDice if gridType == GridType.draft else PlayerDice.RewardDice
	
	for faceIndex in (rewardDice[dieIndex].num_faces() if rewardTab else scoreDice[dieIndex].num_faces()):
		var newFaceUIInstance = DieFaceUIScene.instantiate() as DieFaceUI
		var type = rewardDice[dieIndex].faces[faceIndex].type \
			if rewardTab else scoreDice[dieIndex].faces[faceIndex].type
		var value = rewardDice[dieIndex].faces[faceIndex].value \
			if rewardTab else scoreDice[dieIndex].faces[faceIndex].value
		var dieFace = DieFace.new(value, type)
		var enableFocus = true if gridType == GridType.allDiceFaceChoice or gridType == GridType.faceChoice else false
		newFaceUIInstance.initialize(dieFace, faceIndex, enableFocus)
		
		match gridType:
			GridType.faceChoice,\
			GridType.allDiceFaceChoice:
				newFaceUIInstance.faceSelected.connect(face_selected)
				newFaceUIInstance.focus_mode = Control.FOCUS_CLICK
			_:
				newFaceUIInstance.focus_mode = Control.FOCUS_NONE
				
		faceGrid.add_child(newFaceUIInstance)

func face_selected(faceIndex : int):
	print("[DiceGrid] face_selected prev selected " + str(selectedFace) + " with face index " + str(faceIndex))
	#TODO if DiceGrid's type is a face selection we enable/disable the buttons to actually select once a face is chosen or unchosen
	#if gridType == GridType.faceChoice or gridType == GridType.allDiceFaceChoice:
	faceSelected.emit(faceIndex)
	selectedFace = faceIndex

func refresh_grids():
	clear_face_grid()
	remove_die(currentTab)
	#wait to clear the selectedDie value until after refresh so we have index of die to remove
	selectedDie = -1

func remove_die(tab : GridTabs):
	#this doesn't actually remove the die from the grid but instead makes it invisible so I don't have to recalculate the zindexes
	match tab:
		GridTabs.score:
			var child = scoreDiceGrid.get_child(selectedDie)
			child.visible = false
		GridTabs.reward:
			var child = rewardDiceGrid.get_child(selectedDie)
			child.visible = false

func clear_dice_grid():
	for child in scoreDiceGrid.get_children():
		child.queue_free()
	for child in rewardDiceGrid.get_children():
		child.queue_free()

func clear_grids():
	clear_face_grid()
	clear_dice_grid()

func clear_face_grid():
	for child in faceGrid.get_children():
		child.queue_free()
		faceGrid.remove_child(child)

func _on_score_dice_toggled(toggled_on):
	if toggled_on:
		set_tab(GridTabs.score)
		if gridType == GridType.draft:
			var draftNode = get_tree().get_first_node_in_group("DiceDraft")
			draftNode.find_child("ChooseDie").visible = true if draftNode.scoreDraftCount > 0 else false
	else:
		$"DiceTabs/Score Dice".set_pressed_no_signal(true)

func _on_reward_dice_toggled(toggled_on):
	if toggled_on:
		set_tab(GridTabs.reward)
		if gridType == GridType.draft:
			var draftNode = get_tree().get_first_node_in_group("DiceDraft")
			draftNode.find_child("ChooseDie").visible = true if draftNode.rewardDraftCount > 0 else false
	else:
		$"DiceTabs/Reward Dice".set_pressed_no_signal(true)
