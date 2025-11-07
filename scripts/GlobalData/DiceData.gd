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

enum DiceType
{
	score,
	reward,
	special
}

#this are separate types to make generating dice easier
#might not need this once individual dice generation is setup
enum MakeADieType
{
	score,
	multiplier,
	reward,
	addOrRemoveFace,
	special
}

func MakeADie(numFaces : int, type := MakeADieType.score) -> Die:
	print("MakeADie with " + str(numFaces) + " faces of type " + MakeADieType.keys()[type])
	var faces : Array[DieFace]
	
	for i in numFaces:
		var faceType
		match type:
			MakeADieType.score:
				faceType = DieFaceData.FaceType.score
			MakeADieType.multiplier:
				faceType = DieFaceData.FaceType.multiplier
			MakeADieType.reward:
				faceType = DieFaceData.FaceType.reward
		#modulo to prevent overrunning past the set reward values in DieFaceData.RewardType
		faces.append(DieFace.new(i % DieFaceData.RewardType.size() if type == MakeADieType.reward else i + 1, faceType))
	var dieType
	match type:
		MakeADieType.score, \
		MakeADieType.multiplier:
			dieType = DiceType.score
		MakeADieType.reward:
			dieType = DiceType.reward
	
	return Die.new(faces, dieType)

func DebugMakeACoin(type : DiceType, dieFace_1 : DieFace, dieFace_2 : DieFace):
	var faces : Array[DieFace] = []
	faces.append(dieFace_1)
	faces.append(dieFace_2)
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
	dice.append(MakeADie(2, MakeADieType.reward))
	dice.append(DebugMakeACoin(DiceData.DiceType.reward, DieFace.new(DieFaceData.RewardType.addRemoveFace, DieFaceData.FaceType.reward), DieFace.new(DieFaceData.RewardType.addRemoveFace, DieFaceData.FaceType.reward)))
	#dice.append(MakeADie(12, MakeADieType.reward))
	return dice

func StartingDice() -> Array[Die]:
	#simple starting dice func
	#for testing, 
	var dice : Array[Die] = []
	dice.append(D6())
	dice.append(MakeADie(12))
	dice.append(MakeADie(DieFaceCount.coin, MakeADieType.multiplier))
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
