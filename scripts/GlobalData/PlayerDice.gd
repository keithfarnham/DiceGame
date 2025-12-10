extends Node

var ScoreDice : Array[Die]
var RewardDice : Array[Die]
var DraftScoreDice : Array[Die]
var DraftRewardDice : Array[Die]
var RewardStakes : Array[DieFace]
var RerollScore : int
var RerollReward : int
var Money : int

var Round := 1

#func _ready():
	#print("[PlayerDice] Setting up starting dice")
	#ScoreDice = DiceData.StartingDice()
	#RewardDice = DiceData.GenerateRewardDice()

func add_dice(newDice : Array[Die]):
	print(newDice)
	for newDie in newDice:
		add_die(newDie)
	
func add_die(newDie : Die):
	print("[PlayerDice] Adding a new " + str(DiceData.DiceType.keys()[newDie.type]) + "die")
	match newDie.type:
		DiceData.DiceType.score:
			ScoreDice.append(newDie)
		DiceData.DiceType.reward:
			RewardDice.append(newDie)

func remove_die(dieIndexToRemove : int):
	ScoreDice.remove_at(dieIndexToRemove)

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
