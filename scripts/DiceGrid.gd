extends Control

class_name DiceGrid

@onready var scoreDiceGrid = $DiceGridContainer/Panel/AspectRatioContainer/HBoxContainer/ScoreDiceScrollContainer/ScoreDiceGrid as GridContainer
@onready var rewardDiceGrid = $DiceGridContainer/Panel/AspectRatioContainer/HBoxContainer/RewardDiceScrollContainer/RewardDiceGrid as GridContainer
@onready var faceGrid = $DiceGridContainer/Panel/AspectRatioContainer/HBoxContainer/FaceScrollContainer/FaceGrid as GridContainer

var DieUIScene = preload("res://scenes/DieUIScene.tscn")
var DieFaceUIScene = preload("res://scenes/DiceFaceUIScene.tscn")

@export var gridType : GridType

enum GridType {
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
	set_type(gridType)

func set_type(newType : GridType):
	gridType = newType
	print("[DiceGrid] Grid set to " + str(GridType.keys()[newType]))
	match newType:
		GridType.scoreRoll:
			set_tab(GridTabs.score)
			add_dice(PlayerDice.ScoreDice)
		GridType.rewardRoll:
			set_tab(GridTabs.reward)
			add_dice(PlayerDice.RewardDice)
		GridType.allDiceChoice:
			$DiceTabs.visible = true
			#add_die handles which GridTab the dice get inserted into based on the Die's Type/DiceData.DiceType
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

func set_tab(newTab : GridTabs):
	currentTab = newTab
	print("[DiceGrid] set_tab to " + str(GridTabs.keys()[newTab]))
	match newTab:
		GridTabs.score:
			selectedDie = -1
			selectedFace = -1
			$"DiceTabs/Reward Dice".set_pressed_no_signal(false)
			$DiceGridContainer/Panel/AspectRatioContainer/HBoxContainer/RewardDiceScrollContainer.visible = false
			$DiceGridContainer/Panel/AspectRatioContainer/HBoxContainer/ScoreDiceScrollContainer.visible = true
		GridTabs.reward:
			selectedDie = -1
			selectedFace = -1
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
	print("[DiceGrid] die_selected prev selected " + str(selectedDie) + " with die index " + str(dieIndex))
	if selectedDie == dieIndex and faceGrid.visible:
		#hide face UI and unfocus if reselecting the previously selected die
		faceGrid.visible = false
		match currentTab:
			GridTabs.score:
				scoreDiceGrid.get_child(dieIndex).release_focus()
			GridTabs.reward:
				rewardDiceGrid.get_child(dieIndex).release_focus()
		return
	else:
		faceGrid.visible = true
	
	selectedDie = dieIndex
	clear_face_grid()
	var rewardRoll = gridType == GridType.rewardRoll
	for faceIndex in (PlayerDice.RewardDice[dieIndex].num_faces() if rewardRoll else PlayerDice.ScoreDice[dieIndex].num_faces()):
		var newFaceUIInstance = DieFaceUIScene.instantiate() as DieFaceUI
		var type = PlayerDice.RewardDice[dieIndex].faces[faceIndex].type \
			if rewardRoll else PlayerDice.ScoreDice[dieIndex].faces[faceIndex].type
		var value = PlayerDice.RewardDice[dieIndex].faces[faceIndex].value \
			if rewardRoll else PlayerDice.ScoreDice[dieIndex].faces[faceIndex].value
		var dieFace = DieFace.new(value, type)
		var enableFocus = true if gridType == GridType.allDiceFaceChoice or gridType == GridType.faceChoice else false
		newFaceUIInstance.initialize(dieFace, faceIndex, enableFocus)
		newFaceUIInstance.faceSelected.connect(face_selected)
		faceGrid.add_child(newFaceUIInstance)
		
		match gridType:
			GridType.faceChoice,\
			GridType.allDiceFaceChoice:
				newFaceUIInstance.focus_mode = Control.FOCUS_CLICK
			_:
				newFaceUIInstance.focus_mode = Control.FOCUS_NONE

func face_selected(faceIndex : int):
	print("[DiceGrid] face_selected prev selected " + str(selectedFace) + " with face index " + str(faceIndex))
	selectedFace = faceIndex
	
func refresh_grids():
	match currentTab:
		GridTabs.score:
			clear()
			add_dice(PlayerDice.ScoreDice)
			die_selected(selectedDie)
		GridTabs.reward:
			clear()
			add_dice(PlayerDice.RewardDice)
			die_selected(selectedDie)

func clear():
	scoreDiceGrid.queue_free()
	rewardDiceGrid.queue_free()

func clear_face_grid():
	for child in faceGrid.get_children():
		child.queue_free()
		faceGrid.remove_child(child)

func _on_score_dice_toggled(toggled_on):
	if toggled_on:
		set_tab(GridTabs.score)
	else:
		$"DiceTabs/Score Dice".set_pressed_no_signal(true)

func _on_reward_dice_toggled(toggled_on):
	if toggled_on:
		set_tab(GridTabs.reward)
	else:
		$"DiceTabs/Reward Dice".set_pressed_no_signal(true)
