extends Control

class_name DiceGrid

@onready var scoreDiceGrid = $DiceGridContainer/Panel/AspectRatioContainer/HBoxContainer/ScoreDiceScrollContainer/ScoreDiceGrid as GridContainer
@onready var rewardDiceGrid = $DiceGridContainer/Panel/AspectRatioContainer/HBoxContainer/RewardDiceScrollContainer/RewardDiceGrid as GridContainer
@onready var faceGrid = $DiceGridContainer/Panel/AspectRatioContainer/HBoxContainer/FaceScrollContainer/FaceGrid as GridContainer

var DieUIScene = preload("res://scenes/DieUIScene.tscn")
var DieFaceUIScene = preload("res://scenes/DiceFaceUIScene.tscn")
var DefaultGradient = preload("res://gradients/default_gradient.tres")
var MultGradient = preload("res://gradients/multiplier_gradient.tres")
var RewardGradient = preload("res://gradients/reward_gradient.tres")

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
			#faceGrid.focus_mode = Control.FOCUS_CLICK
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
	var newDieUIInstance = DieUIScene.instantiate() as DieUI
	var numFacesNode = newDieUIInstance.find_child("NumFaces") as RichTextLabel
	numFacesNode.text = str(die.num_faces())
	var dieIndexNode = newDieUIInstance.find_child("DieIndex") as RichTextLabel
	dieIndexNode.text = str(dieIndex)
	var dieTypeNode = newDieUIInstance.find_child("DieType") as RichTextLabel
	print("[DiceGrid] die type is " + str(DiceData.DiceType.keys()[die.type]))
	var diceGrid
	match die.type:
		DiceData.DiceType.reward:
			dieTypeNode.text = "Reward"
			newDieUIInstance.icon.gradient = RewardGradient
			diceGrid = rewardDiceGrid
		DiceData.DiceType.score:
			dieTypeNode.text = "Score"
			newDieUIInstance.icon.gradient = DefaultGradient
			diceGrid = scoreDiceGrid
		DiceData.DiceType.multiplier:
			dieTypeNode.text = "Multiplier"
			newDieUIInstance.icon.gradient = MultGradient
			diceGrid = scoreDiceGrid
		_:
			dieTypeNode.text = "Bruh"
	newDieUIInstance.dieSelected.connect(die_selected)
	diceGrid.add_child(newDieUIInstance)

func add_dice(dice : Array[Die]):
	for dieIndex in dice.size():
		#setting up instance of DieUI
		print("[DiceGrid] adding dice at index " + str(dieIndex) + " of type " + str(DiceData.DiceType.keys()[dice[dieIndex].type]))
		add_die(dice[dieIndex], dieIndex)

func die_selected(dieIndex : int):
	print("[DiceGrid] die_selected prev selected " + str(selectedDie) + " with die index " + str(dieIndex) + " and dieFaceGrid node " + str(faceGrid))
	#selectedDieUpdate.emit(dieIndex)
	if selectedDie == dieIndex and faceGrid.visible:
		#hide face UI and unfocus if reselecting the previously selected die
		faceGrid.visible = false
		match currentTab:
			GridTabs.score:
				scoreDiceGrid.get_child(dieIndex).release_focus()
			GridTabs.reward:
				rewardDiceGrid.get_child(dieIndex).release_focus()
	else:
		faceGrid.visible = true
		
	selectedDie = dieIndex
	clear_die_face_grid()
	var rewardRoll = gridType == GridType.rewardRoll
	var sceneRoot = get_tree().current_scene
	#var sceneRoot2 = get_tree().get_first_node_in_group('SceneRoot')
	print("[DiceGrid] sceneroot name " + str(sceneRoot.name))
	for faceIndex in (PlayerDice.RewardDice[dieIndex].num_faces() if rewardRoll else PlayerDice.ScoreDice[dieIndex].num_faces()):
		var newFaceUIInstance = DieFaceUIScene.instantiate()
		var faceIndexNode = newFaceUIInstance.find_child("FaceIndexValue") as Label
		faceIndexNode.text = str(faceIndex)
		var typeNode = newFaceUIInstance.find_child("FaceTypeValue") as Label
		typeNode.text = str(DieFaceData.FaceType.keys()[PlayerDice.RewardDice[dieIndex].faces[faceIndex].type] \
			if rewardRoll else DieFaceData.FaceType.keys()[PlayerDice.ScoreDice[dieIndex].faces[faceIndex].type])
		var valueNode = newFaceUIInstance.find_child("FaceValueValue") as Label
		valueNode.text = str(DieFaceData.RewardType.keys()[PlayerDice.RewardDice[dieIndex].faces[faceIndex].value] \
			if rewardRoll else PlayerDice.ScoreDice[dieIndex].faces[faceIndex].value)
		match gridType:
			GridType.faceChoice,\
			GridType.allDiceFaceChoice:
				newFaceUIInstance.focus_mode = Control.FOCUS_CLICK
			_:
				newFaceUIInstance.focus_mode = Control.FOCUS_NONE
		newFaceUIInstance.connect("faceSelected", face_selected)
		faceGrid.add_child(newFaceUIInstance)

func face_selected(faceIndex : int):
	print("[DiceGrid] die_selected prev selected " + str(selectedFace) + " with die index " + str(faceIndex))
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

func clear_die_face_grid():
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
