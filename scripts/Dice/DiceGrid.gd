extends Control

class_name DiceGrid

@onready var scoreDiceGrid = $DiceGridContainer/Panel/AspectRatioContainer/HBoxContainer/ScoreDiceScrollContainer/ScoreDiceGrid as GridContainer
@onready var rewardDiceGrid = $DiceGridContainer/Panel/AspectRatioContainer/HBoxContainer/RewardDiceScrollContainer/RewardDiceGrid as GridContainer
@onready var faceGrid = $DiceGridContainer/Panel/AspectRatioContainer/HBoxContainer/FaceScrollContainer/FaceGrid as GridContainer
@onready var gridTabs = $DiceTabs as Control

var DieUIScene = preload("res://scenes/DieUIScene.tscn")
var DieFaceUIScene = preload("res://scenes/DiceFaceUIScene.tscn")

signal faceSelected(faceIndex : int)
signal dieSelected(dieIndex : int, isUnselect : bool)

@export var gridType : GridType

enum GridType {
	DRAFT,
	SCORE_ROLL,
	REWARD_ROLL,
	_REWARD_CHOICES,#below are the different reward choice types
		ALL_DICE_CHOICE, #for selecting a single die from all dice
		ALL_DICE_FACE_CHOICE, #for selecting a single die face from all dice
		SCORE_FACE_CHOICE, #for selecting a single face on a score die,
		SCORE_DIE_CHOICE, #for selecting a single score die
}

enum GridTabs {
	SCORE,
	REWARD
}

#TODO setup die sorting
enum SortType {
	TYPE,
	NUM_FACES
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
		GridType.DRAFT:
			set_tab(GridTabs.SCORE)
			$DiceTabs.visible = true
			add_dice(PlayerDice.DraftScoreDice)
			add_dice(PlayerDice.DraftRewardDice)
			faceGrid.focus_mode = Control.FOCUS_NONE
		GridType.SCORE_ROLL:
			set_tab(GridTabs.SCORE)
			add_dice(PlayerDice.ScoreDice)
		GridType.REWARD_ROLL:
			set_tab(GridTabs.REWARD)
			add_dice(PlayerDice.RewardDice)
		GridType.ALL_DICE_CHOICE:
			$DiceTabs.visible = true
			add_dice(PlayerDice.ScoreDice)
			add_dice(PlayerDice.RewardDice)
			faceGrid.focus_mode = Control.FOCUS_NONE
		GridType.ALL_DICE_FACE_CHOICE:
			$DiceTabs.visible = true
			add_dice(PlayerDice.ScoreDice)
			add_dice(PlayerDice.RewardDice)
		GridType.SCORE_FACE_CHOICE:
			$"DiceTabs/Reward Dice".visible = false
			set_tab(GridTabs.SCORE)
			add_dice(PlayerDice.ScoreDice)
			faceGrid.focus_mode = Control.FOCUS_CLICK
		GridType.SCORE_DIE_CHOICE:
			$"DiceTabs/Reward Dice".visible = false
			set_tab(GridTabs.SCORE)
			add_dice(PlayerDice.ScoreDice)

func set_type(newType : GridType):
	visible = true
	gridType = newType
	Log.print("[DiceGrid] Grid type set to " + str(GridType.keys()[newType]))
	clear_grids()
	populate_grid()

func set_tab(newTab : GridTabs):
	currentTab = newTab
	Log.print("[DiceGrid] set_tab to " + str(GridTabs.keys()[newTab]))
	clear_face_grid()
	selectedDie = -1
	selectedFace = -1
	match newTab:
		GridTabs.SCORE:
			$"DiceTabs/Score Dice".set_pressed_no_signal(true)
			$"DiceTabs/Reward Dice".set_pressed_no_signal(false)
			$DiceGridContainer/Panel/AspectRatioContainer/HBoxContainer/RewardDiceScrollContainer.visible = false
			$DiceGridContainer/Panel/AspectRatioContainer/HBoxContainer/ScoreDiceScrollContainer.visible = true
		GridTabs.REWARD:
			$"DiceTabs/Reward Dice".set_pressed_no_signal(true)
			$"DiceTabs/Score Dice".set_pressed_no_signal(false)
			$DiceGridContainer/Panel/AspectRatioContainer/HBoxContainer/ScoreDiceScrollContainer.visible = false
			$DiceGridContainer/Panel/AspectRatioContainer/HBoxContainer/RewardDiceScrollContainer.visible = true

func add_die(die : Die, dieIndex : int):
	var diceGrid
	Log.print("[DiceGrid] die type is " + str(DiceData.DiceType.keys()[die.type]))
	match die.type:
		DiceData.DiceType.REWARD:
			diceGrid = rewardDiceGrid
		DiceData.DiceType.SCORE:
			diceGrid = scoreDiceGrid
	#the newDieUIInstance needs to be added to the tree before I can assign child nodes their data
	#so I do the initialize() to setup the data in the DieUI class, then when add_child() is called 
	#the DieUI's _ready() will assign the data to the child nodes
	var newDieUIInstance = DieUIScene.instantiate() as DieUI
	newDieUIInstance.initialize(die, dieIndex)
	newDieUIInstance.dieSelected.connect(die_selected)
	diceGrid.add_child(newDieUIInstance)

func add_dice(dice : Array[Die]):
	for dieIndex in range(dice.size()):
		Log.print("[DiceGrid] adding dice at index " + str(dieIndex) + " of type " + str(DiceData.DiceType.keys()[dice[dieIndex].type]))
		add_die(dice[dieIndex], dieIndex)

func die_selected(dieIndex : int):
	Log.print("[DiceGrid] die_selected prev selected " + str(selectedDie) + " with die index " + str(dieIndex))
	var draftNode
	if gridType == GridType.DRAFT:
		draftNode = get_tree().get_first_node_in_group("DiceDraft")
	if selectedDie == dieIndex and faceGrid.visible:
		#hide face UI and unfocus if reselecting the previously selected die
		selectedDie = -1
		faceGrid.visible = false
		if gridType == GridType.DRAFT:
			draftNode.find_child("ChooseDie").text = "Select a Die"
			draftNode.find_child("ChooseDie").disabled = true
			draftNode.find_child("ChooseDie").focus_mode = Control.FOCUS_NONE
		match currentTab:
			GridTabs.SCORE:
				scoreDiceGrid.get_child(dieIndex).release_focus()
			GridTabs.REWARD:
				rewardDiceGrid.get_child(dieIndex).release_focus()
		#have to emit select before early out. Passing true for isUnselect 
		dieSelected.emit(dieIndex, true)
		return
	else:
		faceGrid.visible = true
	
	if gridType == GridType.DRAFT:
		draftNode.find_child("ChooseDie").text = "Choose Selected Die"
		draftNode.find_child("ChooseDie").disabled = false
		draftNode.find_child("ChooseDie").visible = true
		draftNode.find_child("ChooseDie").focus_mode = Control.FOCUS_CLICK
	
	selectedDie = dieIndex
	clear_face_grid()
	var rewardTab = currentTab == GridTabs.REWARD
	var scoreDice = PlayerDice.DraftScoreDice if gridType == GridType.DRAFT else PlayerDice.ScoreDice
	var rewardDice = PlayerDice.DraftRewardDice if gridType == GridType.DRAFT else PlayerDice.RewardDice
	
	for faceIndex in (rewardDice[dieIndex].num_faces() if rewardTab else scoreDice[dieIndex].num_faces()):
		var newFaceUIInstance = DieFaceUIScene.instantiate() as DieFaceUI
		var type = rewardDice[dieIndex].faces[faceIndex].type \
			if rewardTab else scoreDice[dieIndex].faces[faceIndex].type
		var value = rewardDice[dieIndex].faces[faceIndex].value \
			if rewardTab else scoreDice[dieIndex].faces[faceIndex].value
		var dieFace = DieFace.new(value, type)
		var enableFocus = true if gridType == GridType.ALL_DICE_FACE_CHOICE or gridType == GridType.SCORE_FACE_CHOICE else false
		newFaceUIInstance.initialize(dieFace, faceIndex, enableFocus)
		
		match gridType:
			GridType.SCORE_FACE_CHOICE,\
			GridType.ALL_DICE_FACE_CHOICE:
				newFaceUIInstance.faceSelected.connect(face_selected)
				newFaceUIInstance.focus_mode = Control.FOCUS_CLICK
			_:
				newFaceUIInstance.focus_mode = Control.FOCUS_NONE
				
		faceGrid.add_child(newFaceUIInstance)
	#filling out the facegrid before emitting to have the nodes setup for anything RewardHandler is doing to the grid UI
	dieSelected.emit(dieIndex, false)

func face_selected(faceIndex : int):
	Log.print("[DiceGrid] face_selected prev selected " + str(selectedFace) + " with face index " + str(faceIndex))
	faceSelected.emit(faceIndex)
	selectedFace = faceIndex

func draft_die_selected():
	clear_face_grid()
	hide_die(currentTab)
	#wait to clear the selectedDie value until after refresh so we have index of die to remove
	selectedDie = -1

func hide_die(tab : GridTabs):
	#this doesn't actually remove the die from the grid but instead makes it invisible so I don't have to recalculate the zindexes
	match tab:
		GridTabs.SCORE:
			var child = scoreDiceGrid.get_child(selectedDie)
			child.visible = false
		GridTabs.REWARD:
			var child = rewardDiceGrid.get_child(selectedDie)
			child.visible = false

func refresh_grids():
	clear_grids()
	populate_grid()
	
func refresh_face_grid():
	clear_face_grid()
	var rewardTab = currentTab == GridTabs.REWARD
	for faceIndex in (PlayerDice.RewardDice[selectedDie].num_faces() if rewardTab else PlayerDice.ScoreDice[selectedDie].num_faces()):
		var newFaceUIInstance = DieFaceUIScene.instantiate() as DieFaceUI
		var type = PlayerDice.RewardDice[selectedDie].faces[faceIndex].type \
			if rewardTab else PlayerDice.ScoreDice[selectedDie].faces[faceIndex].type
		var value = PlayerDice.RewardDice[selectedDie].faces[faceIndex].value \
			if rewardTab else PlayerDice.ScoreDice[selectedDie].faces[faceIndex].value
		var dieFace = DieFace.new(value, type)
		var enableFocus = true if gridType == GridType.ALL_DICE_FACE_CHOICE or gridType == GridType.SCORE_FACE_CHOICE else false
		newFaceUIInstance.initialize(dieFace, faceIndex, enableFocus)
		faceGrid.add_child(newFaceUIInstance)

func clear_dice_grid():
	for child in scoreDiceGrid.get_children():
		child.queue_free()
	for child in rewardDiceGrid.get_children():
		child.queue_free()

func clear_grids():
	selectedDie = -1
	selectedFace = -1
	clear_face_grid()
	clear_dice_grid()

func clear_face_grid():
	for child in faceGrid.get_children():
		child.queue_free()
		faceGrid.remove_child(child)
		
func toggle_die_grid_focus(enable : bool):
	scoreDiceGrid.mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_ENABLED if enable else Control.MOUSE_BEHAVIOR_DISABLED
	rewardDiceGrid.mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_ENABLED if enable else Control.MOUSE_BEHAVIOR_DISABLED
	$"DiceTabs/Score Dice".mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_ENABLED if enable else Control.MOUSE_BEHAVIOR_DISABLED
	$"DiceTabs/Reward Dice".mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_ENABLED if enable else Control.MOUSE_BEHAVIOR_DISABLED

func toggle_die_face_focus(selectedFaceIndex : int, enable : bool):
	faceGrid.get_child(selectedFaceIndex).disabled = true
	faceGrid.get_child(selectedFaceIndex).focus_mode = Control.FOCUS_CLICK if enable else Control.FOCUS_NONE
	
func set_border_style_for_face(faceIndex : int, styleType : DieFaceUI.StyleBorderType):
	faceGrid.get_child(faceIndex).set_border_type(styleType)

func _on_score_dice_toggled(toggled_on):
	if toggled_on:
		set_tab(GridTabs.SCORE)
		if gridType == GridType.DRAFT:
			var draftNode = get_tree().get_first_node_in_group("DiceDraft")
			draftNode.find_child("ChooseDie").visible = true if draftNode.scoreDraftCount > 0 else false
	else:
		$"DiceTabs/Score Dice".set_pressed_no_signal(true)

func _on_reward_dice_toggled(toggled_on):
	if toggled_on:
		set_tab(GridTabs.REWARD)
		if gridType == GridType.DRAFT:
			var draftNode = get_tree().get_first_node_in_group("DiceDraft")
			draftNode.find_child("ChooseDie").visible = true if draftNode.rewardDraftCount > 0 else false
	else:
		$"DiceTabs/Reward Dice".set_pressed_no_signal(true)
