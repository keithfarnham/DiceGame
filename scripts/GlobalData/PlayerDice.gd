extends Node

var ScoreDice : Array[Die]
var RewardDice : Array[Die]
var RewardStakes : Array[DieFace]
var DebugDie : Die
var Money : int
var prevSelect := -1

signal add_to_dice_grid

func _ready():
	DebugDie = Die.new([], DiceData.DiceTypes.score)
	
func add_dice(newDice : Array[Die]):
	for newDie in newDice:
		add_die(newDie)
	
func add_die(newDie : Die):
	#print_tree_pretty()
	#print(get_tree().get_first_node_in_group('SceneRoot').get_tree_string_pretty())
	#print("______________________")
	var diceGrid = get_tree().get_first_node_in_group('SceneRoot').get_node('DiceGridControl').get_node('DiceGridContainer').get_node('Panel').get_node('AspectRatioContainer').get_node('HBoxContainer').get_node('DiceScrollContainer').get_node('DiceGrid') as DiceGrid
	#print(str(get_tree().get_first_node_in_group('SceneRoot').get_tree_string_pretty()))
	ScoreDice.append(newDie)
	var dieIndex = ScoreDice.size() - 1
	diceGrid.add_die(newDie, dieIndex)
	
	
	#add_to_dice_grid.emit()
	
#TODO convert all this stuff to grab the scene tree and proper nodes
func remove_die(dieIndexToRemove : int):
	prevSelect = -1
	ScoreDice.remove_at(dieIndexToRemove)
	print(get_tree_string())
	var diceGrid = get_tree().get_first_node_in_group('SceneRoot').get_node("DiceUI").get_node("DiceGridScroll").get_node("DiceGrid")
	#var debugNode = get_tree().current_scene.get_node('DebugControls')
	#var diceGrid = debugNode.get_node('DiceGrid')
	#diceGrid.remove_child(diceGrid.get_child(dieIndexToRemove))
	#for i in diceGrid.get_children().size():
		#var a = diceGrid.get_children()[i] as DieUI
		#a.dieIndexUI.text = str(i)
	#for child in dieFaceGrid.get_children():
		#dieFaceGrid.remove_child(child)

func add_money(add : int):
	Money += add
	
func remove_money(remove : int):
	Money -= remove

func debug_print_dice_array(type = DiceData.DiceTypes.score):
	var string = ""
	var Dice = RewardDice if type == DiceData.DiceTypes.reward else ScoreDice
	for dieIndex in Dice.size():
		var numFaces = Dice[dieIndex].faces.size()
		string += "\n[u]Die " + str(dieIndex) + " w/ " + str(numFaces) + " faces: [/u]"
		for faceIndex in Dice[dieIndex].faces.size():
			match Dice[dieIndex].faces[faceIndex].type:
				DieFaceData.FaceType.multiplier:
					string += "[b]"
				DieFaceData.FaceType.special:
					string += "[u]"
			string += "[" + str(Dice[dieIndex].faces[faceIndex].value) + "]"
			match Dice[dieIndex].faces[faceIndex].type:
				DieFaceData.FaceType.multiplier:
					string += "[/b]"
				DieFaceData.FaceType.special:
					string += "[/u]"
	print_rich(string)
