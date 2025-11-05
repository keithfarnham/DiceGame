extends Node

var ScoreDice : Array[Die]
var RewardDice : Array[Die]
var RewardStakes : Array[DieFace]
var RerollScore : int
var RerollReward : int
var Money : int

func _ready():
	print("[PlayerDice] Setting up starting dice")
	ScoreDice = DiceData.StartingDice()
	RewardDice = DiceData.GenerateRewardDice()

func add_dice(newDice : Array[Die]):
	print(newDice)
	for newDie in newDice:
		add_die(newDie)
	
func add_die(newDie : Die):
	#print_tree_pretty()
	#print(get_tree().get_first_node_in_group('SceneRoot').get_tree_string_pretty())
	#print("______________________")
	#var diceGrid = get_tree().get_first_node_in_group('SceneRoot').get_node('DiceGrid') as DiceGrid
	#print(str(get_tree().get_first_node_in_group('SceneRoot').get_tree_string_pretty()))
	print("[PlayerDice] Adding a new die")
	ScoreDice.append(newDie)

#TODO convert all this stuff to grab the scene tree and proper nodes
func remove_die(dieIndexToRemove : int):
	ScoreDice.remove_at(dieIndexToRemove)
	#print(get_tree_string())
	#var diceGrid = get_tree().get_first_node_in_group('SceneRoot').get_node("DiceUI").get_node("DiceGridScroll").get_node("DiceGrid")
	#var debugNode = get_tree().current_scene.get_node('DebugControls')
	#var diceGrid = debugNode.get_node('DiceGrid')
	#diceGrid.remove_child(diceGrid.get_child(dieIndexToRemove))
	#for i in diceGrid.get_children().size():
		#var a = diceGrid.get_children()[i] as DieUI
		#a.dieIndexUI.text = str(i)
	#for child in dieFaceGrid.get_children():
		#dieFaceGrid.remove_child(child)

func debug_print_dice_array(type = DiceData.DiceType.score):
	var string = ""
	var Dice = RewardDice if type == DiceData.DiceType.reward else ScoreDice
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
