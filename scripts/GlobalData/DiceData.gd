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

#These are mostly used for quick setup of dice with all faces being a single FaceType
enum DiceTypes
{
	score = 0,
	multiplier = 1,
	special = 2,
	reward = 3
}

var DiceTypesWeights = {
	DiceTypes.score: 50,
	DiceTypes.multiplier: 10,
	DiceTypes.special: 5,
	DiceTypes.reward: 1
}

func MakeADie(numFaces : int, type := DiceTypes.score) -> Die:
	print("MakeADie with " + str(numFaces) + " faces of type " + DiceTypes.keys()[type])
	var faces : Array[DieFace]
	for i in numFaces:
		#TODO adjust the modulo value after adding more reward value types
		#this is to prevent overrunning past the set reward values in DieFaceData.RewardTypeValue, i have 7 reward values currently setup
		faces.append(DieFace.new(i % 7 if type == DiceTypes.reward else i + 1, type as DieFaceData.FaceType))
	return Die.new(faces, type)

func DebugSimpleRewardD6():
	var faces : Array[DieFace]
	for i in DieFaceCount.D6:
		faces.append(DieFace.new(i + 1, DieFaceData.FaceType.reward))
	return Die.new(faces, DiceTypes.reward)

func GenerateRewardDice() -> Array[Die]:
	print("Generating Reward Dice")
	#TODO make this make random reward dice
	#TODO rarity+weighting by powerlevel?
	var dice : Array[Die] = []
	dice.append(DebugSimpleRewardD6())
	dice.append(MakeADie(2, DiceTypes.reward))
	dice.append(MakeADie(12, DiceTypes.reward))
	return dice

func StartingDice() -> Array[Die]:
	#simple starting dice func
	#for testing, 
	var dice : Array[Die] = []
	dice.append(D6())
	dice.append(MakeADie(12))
	dice.append(MakeADie(DieFaceCount.coin, DiceTypes.multiplier))
	return dice

#func Coin(type := DiceTypes.score) -> Die:
	#var faces : Array[DieFace]
	#var faceType := DieFaceData.FaceType.score
	#match type:
		#DiceTypes.score:
			#faceType = DieFaceData.FaceType.score
		#DiceTypes.multiplier:
			#faceType = DieFaceData.FaceType.multiplier
		#DiceTypes.reward:
			#faceType = DieFaceData.FaceType.reward
	#for i in DieFaceCount.coin:
		#faces.append(DieFace.new(i + 1, faceType))
	#print("making Coin with type " + str(DiceTypes.keys()[type]))
	#return Die.new(faces, type)

func D6(type := DiceTypes.score) -> Die:
	#TODO modify to support creation of reward D6 as well
	#maybe add a few default dice types to create, like all a D6 with all money reward faces from $1-6
	var faces : Array[DieFace]
	var faceType := DieFaceData.FaceType.score
	match type:
		DiceTypes.score:
			faceType = DieFaceData.FaceType.score
		DiceTypes.reward:
			faceType = DieFaceData.FaceType.reward
	for i in DieFaceCount.D6:
		faces.append(DieFace.new(i + 1, faceType))
	print("making D6 with type " + str(DiceTypes.keys()[type]))
	return Die.new(faces, type)
