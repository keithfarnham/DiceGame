extends Node

var ScoreDice : Array[Die]
var RewardDice : Array[Die]
var DraftScoreDice : Array[Die]
var DraftRewardDice : Array[Die]
var RewardStakes : Array[DieFace]
#var RerollScore : int
#var RerollReward : int
var Money : int
var ChosenClass : PlayerClass.ClassChoice

#TODO might want to move these elsewhere
var TotalRounds := 1
var BossRound := false
var DEBUG_Enabled := false

func new_game():
	ScoreDice = []
	RewardDice = []
	DraftScoreDice = []
	DraftRewardDice = []
	RewardStakes = []
	Money = 0
	ChosenClass = -1
	TotalRounds = 1
	BossRound = false

func add_dice(newDice : Array[Die]):
	print(newDice)
	for newDie in newDice:
		add_die(newDie)
	
func add_die(newDie : Die):
	Log.print("[PlayerDice] Adding a new " + str(DiceData.DiceType.keys()[newDie.type]) + "die")
	match newDie.type:
		DiceData.DiceType.SCORE:
			ScoreDice.append(newDie)
		DiceData.DiceType.REWARD:
			RewardDice.append(newDie)

func remove_die(dieIndexToRemove : int):
	ScoreDice.remove_at(dieIndexToRemove)
	
func get_score_die_min_face_index(dieIndex) -> int:
	var minFaceIndex
	var minFaceValue
	var die = PlayerDice.ScoreDice[dieIndex]
	for faceIndex in die.faces.size():
		if minFaceValue == null or minFaceValue > die.faces[faceIndex].value:
			minFaceValue = die.faces[faceIndex].value
			minFaceIndex = faceIndex
	return minFaceIndex
	
func get_score_die_max_face_index(dieIndex) -> int:
	var maxFaceIndex
	var maxFaceValue
	var die = PlayerDice.ScoreDice[dieIndex]
	for faceIndex in die.faces.size():
		if maxFaceValue == null or die.faces[faceIndex].value > maxFaceValue:
			maxFaceValue = die.faces[faceIndex].value
			maxFaceIndex = faceIndex
	return maxFaceIndex

func debug_print_dice_array(type = DiceData.DiceType.SCORE):
	var string = ""
	var Dice = RewardDice if type == DiceData.DiceType.REWARD else ScoreDice
	for dieIndex in Dice.size():
		var numFaces = Dice[dieIndex].faces.size()
		string += "\n[u]Die " + str(dieIndex) + " w/ " + str(numFaces) + " faces: [/u]"
		for faceIndex in Dice[dieIndex].faces.size():
			match Dice[dieIndex].faces[faceIndex].type:
				DieFaceData.FaceType.MULTIPLIER:
					string += "[b]"
				DieFaceData.FaceType.SPECIAL:
					string += "[u]"
			string += "[" + str(Dice[dieIndex].faces[faceIndex].value) + "]"
			match Dice[dieIndex].faces[faceIndex].type:
				DieFaceData.FaceType.MULTIPLIER:
					string += "[/b]"
				DieFaceData.FaceType.SPECIAL:
					string += "[/u]"
	print_rich(string)
