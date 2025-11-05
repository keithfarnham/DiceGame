extends Node

enum DieFaceCount
{
	coin = 2,
	D3 = 3,
	D4 = 4,
	D5 = 5,
	hand = 5,
	D6 = 6,
	D8 = 8,
	D10 = 10,
	D12 = 12,
	D20 = 20
}

var DieFaceCountWeight = {
	DieFaceCount.coin: 10,
	DieFaceCount.D3: 8,
	DieFaceCount.D4: 6,
	DieFaceCount.D5: 4,
	DieFaceCount.D6: 2,
	DieFaceCount.D8: 4,
	DieFaceCount.D10: 6,
	DieFaceCount.D12: 8,
	DieFaceCount.D20: 10
}

var DiceTypesWeights = {
	DiceType.score: 50,
	DiceType.multiplier: 10,
	DiceType.special: 5,
	DiceType.reward: 1
}

enum DiceType
{
	score = 0,
	multiplier = 1,
	special = 2,
	reward = 3
}

func MakeADie(numFaces : int, type := DiceType.score) -> Die:
	print("MakeADie with " + str(numFaces) + " faces of type " + DiceType.keys()[type])
	var faces : Array[DieFace]
	for i in numFaces:
		#modulo to prevent overrunning past the set reward values in DieFaceData.RewardType
		faces.append(DieFace.new(i % DieFaceData.RewardType.size() if type == DiceType.reward else i + 1, type as DieFaceData.FaceType))
	return Die.new(faces, type)

func DebugSimpleRewardD6():
	var faces : Array[DieFace]
	for i in DieFaceCount.D6:
		faces.append(DieFace.new(i + 1, DieFaceData.FaceType.reward))
	return Die.new(faces, DiceType.reward)

func GenerateRewardDice() -> Array[Die]:
	print("Generating Reward Dice")
	#TODO make this make random reward dice
	#rarity+weighting by powerlevel?
	var dice : Array[Die] = []
	dice.append(DebugSimpleRewardD6())
	dice.append(MakeADie(2, DiceType.reward))
	dice.append(MakeADie(12, DiceType.reward))
	return dice

func StartingDice() -> Array[Die]:
	#simple starting dice func
	#for testing, 
	var dice : Array[Die] = []
	dice.append(D6())
	dice.append(MakeADie(12))
	dice.append(MakeADie(DieFaceCount.coin, DiceType.multiplier))
	return dice

func D6(type := DiceType.score) -> Die:
	#TODO modify to support creation of reward D6 as well
	#maybe add a few default dice types to create, like all a D6 with all money reward faces from $1-6
	var faces : Array[DieFace]
	var faceType := DieFaceData.FaceType.score
	match type:
		DiceType.score:
			faceType = DieFaceData.FaceType.score
		DiceType.reward:
			faceType = DieFaceData.FaceType.reward
	for i in DieFaceCount.D6:
		faces.append(DieFace.new(i + 1, faceType))
	print("making D6 with type " + str(DiceType.keys()[type]))
	return Die.new(faces, type)
