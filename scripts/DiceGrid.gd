extends Control

class_name DiceGrid

@onready var diceGrid = $DiceGridContainer/Panel/AspectRatioContainer/HBoxContainer/DiceScrollContainer/DiceGrid as GridContainer
@onready var faceGrid = $DiceGridContainer/Panel/AspectRatioContainer/HBoxContainer/FaceScrollContainer/FaceGrid as GridContainer

var DieUIScene = preload("res://scenes/DieUIScene.tscn")
var DieFaceUIScene = preload("res://scenes/DiceFaceUIScene.tscn")
var DefaultGradient = preload("res://gradients/default_gradient.tres")
var MultGradient = preload("res://gradients/multiplier_gradient.tres")
var RewardGradient = preload("res://gradients/reward_gradient.tres")

@export var gridType := DiceData.DiceTypes.score

var prevSelect := -1

func _ready():
	match gridType:
		DiceData.DiceTypes.score:
			print("[DiceGrid] adding score dice")
			add_dice(PlayerDice.ScoreDice)
		DiceData.DiceTypes.reward:
			print("[DiceGrid] adding reward dice")
			add_dice(PlayerDice.RewardDice)

func add_die(die : Die, dieIndex : int):
	var newDieUIInstance = DieUIScene.instantiate() as DieUI
	var numFacesNode = newDieUIInstance.find_child("NumFaces") as RichTextLabel
	numFacesNode.text = str(die.num_faces())
	var dieIndexNode = newDieUIInstance.find_child("DieIndex") as RichTextLabel
	dieIndexNode.text = str(dieIndex)
	var dieTypeNode = newDieUIInstance.find_child("DieType") as RichTextLabel
	print("[DiceGrid] die type is " + str(DiceData.DiceTypes.keys()[die.type]))
	match die.type:
		DiceData.DiceTypes.reward:
			dieTypeNode.text = "Reward"
			newDieUIInstance.icon.gradient = RewardGradient
		DiceData.DiceTypes.score:
			dieTypeNode.text = "Score"
			newDieUIInstance.icon.gradient = DefaultGradient
		DiceData.DiceTypes.multiplier:
			dieTypeNode.text = "Multiplier"
			newDieUIInstance.icon.gradient = MultGradient
		_:
			dieTypeNode.text = "Bruh"
	newDieUIInstance.dieSelected.connect(die_selected)
	diceGrid.add_child(newDieUIInstance)

func add_dice(dice : Array[Die]):
	for dieIndex in dice.size():
		#setting up instance of DieUI
		print("[DiceGrid] adding dice at index " + str(dieIndex) + " of type " + str(DiceData.DiceTypes.keys()[dice[dieIndex].type]))
		add_die(dice[dieIndex], dieIndex)

func die_selected(dieIndex : int):
	#print("WHOLE TREE")
	#print_tree_pretty()
	#print("END TREE")
	#var dieFaceGrid = get_parent().get_parent().get_node("FaceScrollContainer").get_node("FaceGrid") as GridContainer
	#print(get_parent().get_parent().get_tree_string())
	print("[DiceGrid] die_selected prev selected " + str(prevSelect) + " with die index " + str(dieIndex) + " and dieFaceGrid node " + str(faceGrid))
	#selectedDieUpdate.emit(dieIndex)
	if prevSelect == dieIndex and faceGrid.visible:
		#hide face UI and unfocus if reselecting the previously selected die
		faceGrid.visible = false
		diceGrid.get_child(dieIndex).release_focus()
	else:
		faceGrid.visible = true
		
	prevSelect = dieIndex
	clear_die_face_grid()
	var reward = gridType == DiceData.DiceTypes.reward
	var sceneRoot = get_tree().current_scene
	#var sceneRoot2 = get_tree().get_first_node_in_group('SceneRoot')
	print("[DiceGrid] sceneroot name " + str(sceneRoot.name))
	for faceIndex in (PlayerDice.RewardDice[dieIndex].num_faces() if reward else PlayerDice.ScoreDice[dieIndex].num_faces()):
		var newFaceUIInstance = DieFaceUIScene.instantiate()
		var faceIndexNode = newFaceUIInstance.find_child("FaceIndexValue") as Label
		faceIndexNode.text = str(faceIndex)
		var typeNode = newFaceUIInstance.find_child("FaceTypeValue") as Label
		typeNode.text = str(DieFaceData.FaceType.keys()[PlayerDice.RewardDice[dieIndex].faces[faceIndex].type] \
			if reward else DieFaceData.FaceType.keys()[PlayerDice.ScoreDice[dieIndex].faces[faceIndex].type])
		var valueNode = newFaceUIInstance.find_child("FaceValueValue") as Label
		valueNode.text = str(DieFaceData.RewardTypeValue.keys()[PlayerDice.RewardDice[dieIndex].faces[faceIndex].value] \
			if reward else PlayerDice.ScoreDice[dieIndex].faces[faceIndex].value)
		faceGrid.add_child(newFaceUIInstance)

func clear():
	diceGrid.queue_free()
	

func clear_die_face_grid():
	for child in faceGrid.get_children():
		child.queue_free()
		faceGrid.remove_child(child)
	
	#TODO this breaks
	#dieFaceGrid.clear()
	
	#for child in get_node('DieFaceGrid').get_children():
		#get_node('DieFaceGrid').remove_child(child)
