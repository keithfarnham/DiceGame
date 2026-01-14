#extends Resource?
extends Node

#class_name DiceData

enum DieFaceCount
{
	Coin = 2,
	D3 = 3,
	D4 = 4,
	D5 = 5,
	#hand = 5,
	D6 = 6,
	D8 = 8,
	D10 = 10,
	D12 = 12,
	D16 = 16,
	D20 = 20
}

enum DieRarity
{
	COMMON,
	UNCOMMON,
	RARE,
	LEGENDARY
}

static var DieFaceCountWeight = {
	DieFaceCount.D3: 	{DieRarity.COMMON:2, DieRarity.UNCOMMON:2, DieRarity.RARE:3, DieRarity.LEGENDARY:4},
	DieFaceCount.D4:	{DieRarity.COMMON:3, DieRarity.UNCOMMON:2, DieRarity.RARE:3, DieRarity.LEGENDARY:4},
	DieFaceCount.D5: 	{DieRarity.COMMON:5, DieRarity.UNCOMMON:2, DieRarity.RARE:3, DieRarity.LEGENDARY:4},
	DieFaceCount.Coin: 	{DieRarity.COMMON:1, DieRarity.UNCOMMON:2, DieRarity.RARE:3, DieRarity.LEGENDARY:4},
	DieFaceCount.D6: 	{DieRarity.COMMON:7, DieRarity.UNCOMMON:2, DieRarity.RARE:3, DieRarity.LEGENDARY:4},
	DieFaceCount.D8: 	{DieRarity.COMMON:5, DieRarity.UNCOMMON:2, DieRarity.RARE:3, DieRarity.LEGENDARY:4},
	DieFaceCount.D10: 	{DieRarity.COMMON:4, DieRarity.UNCOMMON:2, DieRarity.RARE:3, DieRarity.LEGENDARY:4},
	DieFaceCount.D12: 	{DieRarity.COMMON:3, DieRarity.UNCOMMON:2, DieRarity.RARE:3, DieRarity.LEGENDARY:4},
	DieFaceCount.D16: 	{DieRarity.COMMON:2, DieRarity.UNCOMMON:2, DieRarity.RARE:3, DieRarity.LEGENDARY:4},
	DieFaceCount.D20: 	{DieRarity.COMMON:1, DieRarity.UNCOMMON:2, DieRarity.RARE:3, DieRarity.LEGENDARY:4}
}

static var DieFaceTypeWeight = {
	DieFaceData.FaceType.SCORE: 		{DieRarity.COMMON:8, DieRarity.UNCOMMON:6, DieRarity.RARE:5, DieRarity.LEGENDARY:3},
	DieFaceData.FaceType.MULTIPLIER: 	{DieRarity.COMMON:2, DieRarity.UNCOMMON:4, DieRarity.RARE:5, DieRarity.LEGENDARY:7}
}

enum DiceType
{
	SCORE,
	REWARD,
	SPECIAL
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

func make_a_die(numFaces : int, type := MakeADieType.score) -> Die:
	Log.print("MakeADie with " + str(numFaces) + " faces of type " + MakeADieType.keys()[type])
	var faces : Array[DieFace]
	
	for i in numFaces:
		var faceType
		match type:
			MakeADieType.score:
				faceType = DieFaceData.FaceType.SCORE
			MakeADieType.multiplier:
				faceType = DieFaceData.FaceType.MULTIPLIER
			MakeADieType.reward:
				faceType = DieFaceData.FaceType.REWARD
		#modulo to prevent overrunning past the set reward values in DieFaceData.RewardType
		faces.append(DieFace.new(i % DieFaceData.RewardType.size() if type == MakeADieType.reward else i + 1, faceType))
	var newDie
	match type:
		MakeADieType.score, \
		MakeADieType.multiplier:
			newDie = ScoreDie.new(faces)
		MakeADieType.reward:
			newDie = RewardDie.new(faces)
	
	return newDie

func DebugMakeACoin(type : DiceType, dieFace_1 : DieFace, dieFace_2 : DieFace):
	var faces : Array[DieFace] = []
	var newCoin
	faces.append(dieFace_1)
	faces.append(dieFace_2)
	match type:
		DiceType.SCORE:
			newCoin = ScoreDie.new(faces)
		DiceType.REWARD:
			newCoin = RewardDie.new(faces)
	return newCoin

func simple_reward_D6():
	var faces : Array[DieFace]
	for i in DieFaceCount.D6:
		faces.append(DieFace.new(i + 1, DieFaceData.FaceType.REWARD))
	return RewardDie.new(faces)

func sum_face_count_weights_for_rarity(rarity : DieRarity):
	var sum = 0
	for dieFaceCount in DieFaceCountWeight.keys():
		var weights = DieFaceCountWeight.get(dieFaceCount)
		var weightForRarity = weights.get(rarity)
		sum += weightForRarity
	return sum

func sum_face_type_weights_for_rarity(rarity : DieRarity):
	var sum = 0
	for faceType in DieFaceTypeWeight.keys():
		var weights = DieFaceTypeWeight.get(faceType)
		var weightForRarity = weights.get(rarity)
		sum += weightForRarity
	return sum
	
func sum_reward_face_weights_for_rarity(rarity : DieRarity):
	var sum = 0
	for key in DieFaceData.RewardTypeWeights.keys():
		var weights = DieFaceData.RewardTypeWeights.get(key)
		var weightForRarity = weights.get(rarity)
		sum += DieFaceData.RewardTypeWeights.get(key).get(rarity)
	return sum

func random_num_faces_from_rarity(rarity : DieRarity):
	var sum = sum_face_count_weights_for_rarity(rarity)
	var r = randi_range(0, sum - 1)
	for numFaces in DieFaceCountWeight.keys():
		var weights = DieFaceCountWeight.get(numFaces)
		var facesWeight = weights.get(rarity)
		if r < facesWeight:
			Log.print("[DiceData][num_faces] - random num chosen " + str(r) + " for faces from rarity " + str(DieRarity.keys()[rarity]) + " returning numFaces " + str(numFaces))
			return numFaces
		r -= facesWeight
	push_error("ERROR random_num_faces_from_rarity hit something we shouldn't")


func random_score_face_value_from_rarity(maxValue, rarity : DieRarity) -> int:
	#weight of v^p where p depends on rarity, p==0 => uniform distribution
	#TODO change this to make lower rarity have less of a chance to give higher values rather than uniform dist
	var power_map = {
		DieRarity.COMMON: 0.0,
		DieRarity.UNCOMMON: 0.3,
		DieRarity.RARE: 0.6,
		DieRarity.LEGENDARY: 1.0
	}
	var p = power_map.get(rarity)

	var weights = []
	var total = 0.0
	for v in range(1, int(maxValue) + 1):
		var w = pow(float(v), p)
		weights.append(w)
		total += w

	var r = randf() * total
	for i in range(weights.size()):
		if r < weights[i]:
			var chosen = i + 1
			Log.print("[DiceData][score_face_value] - random float " + str(r) + " total " + str(total) + " rarity " + str(DieRarity.keys()[rarity]) + " returning " + str(chosen))
			return chosen
		r -= weights[i]
		
	return int(maxValue) #TODO might want a better backup case here

func random_reward_face_value_from_rarity(rarity : DieRarity):
	var sum = sum_reward_face_weights_for_rarity(rarity)
	var r = randi_range(0, sum - 1)
	for rewardType in DieFaceData.RewardTypeWeights.keys():
		var weights = DieFaceData.RewardTypeWeights.get(rewardType as DieFaceData.RewardType)
		var weightForRarity = weights.get(rarity as DieRarity)
		if r < weightForRarity:
			Log.print("[DiceData][reward_face_value] - random num chosen " + str(r) + " from rarity " + str(DieRarity.keys()[rarity]) + " returning " + str(DieFaceData.RewardType.keys()[rewardType]))
			return rewardType
		r -= weightForRarity
	push_error("ERROR random_reward_face_value_from_rarity hit something we shouldn't")

func random_face_type_from_rarity(rarity : DieRarity):
	#TODO re-enable
	return randi_range(DieFaceData.FaceType.SCORE, DieFaceData.FaceType.MULTIPLIER)
	#var types = [DieFaceData.FaceType.score, DieFaceData.FaceType.multiplier]
	#var sum = sum_face_type_weights_for_rarity(rarity)
	#var r = randi_range(0, sum)
	#for type in types:
		#var weights = DieFaceTypeWeight.get(type)
		#var typeWeight = weights.get(rarity)
		#if r < typeWeight:
			#Log.print("[DiceData][face_type] - random num chosen " + str(r) + "face type for rarity " + str(DieRarity.keys()[rarity]) + " returning " + str(DieFaceData.FaceType.keys()[type]))
			#return type as DieFaceData.FaceType
		#r -= typeWeight
	#Log.print("ERROR random_face_type_from_rarity hit something we shouldn't")

func random_score_die(rarity : DieRarity, forceNumFaces = -1):
	var numFaces = random_num_faces_from_rarity(rarity) if forceNumFaces == -1 else forceNumFaces
	var faces : Array[DieFace] = []
	for i in numFaces:
		var value = random_score_face_value_from_rarity(numFaces, rarity)
		var type = random_face_type_from_rarity(rarity)
		faces.append(DieFace.new(value, type))
	return ScoreDie.new(faces)
	
func random_reward_die(rarity : DieRarity, forceNumFaces = -1):
	var numFaces = random_num_faces_from_rarity(rarity) if forceNumFaces == -1 else forceNumFaces
	var faces : Array[DieFace] = []
	for i in numFaces:
		var value = random_reward_face_value_from_rarity(rarity)
		var type = DieFaceData.FaceType.REWARD
		faces.append(DieFace.new(value, type))
	return RewardDie.new(faces)

func generate_random_draft_score_dice(numOfDice : int) -> Array[Die]:
	var dice : Array[Die] = []
	for i in numOfDice:
		dice.append(random_score_die(DieRarity.COMMON))
	return dice

func generate_random_draft_reward_dice(numOfDice : int) -> Array[Die]:
	Log.print("Generating Reward Dice")
	var dice : Array[Die] = []
	dice.append(simple_reward_D6())
	dice.append(random_reward_die(DieRarity.COMMON))
	return dice

func generate_starting_dice():
	match PlayerDice.ChosenClass:
		PlayerClass.ClassChoice.StandardGambler:
			PlayerDice.ScoreDice.append(make_a_die(6))
		PlayerClass.ClassChoice.DungeonMaster:
			PlayerDice.ScoreDice.append(make_a_die(20))
		_:
			PlayerDice.ScoreDice.append(D6())
			PlayerDice.RewardDice.append(simple_reward_D6())

func D6(type := DiceType.SCORE) -> Die:
	#TODO modify to support creation of reward D6 as well
	#maybe add a few default dice types to create, like all a D6 with all money reward faces from $1-6
	var faces : Array[DieFace]
	var faceType := DieFaceData.FaceType.SCORE
	match type:
		DiceType.SCORE:
			faceType = DieFaceData.FaceType.SCORE
		DiceType.REWARD:
			faceType = DieFaceData.FaceType.REWARD
	for i in DieFaceCount.D6:
		faces.append(DieFace.new(i + 1, faceType))
	Log.print("making D6 with type " + str(DiceType.keys()[type]))
	return ScoreDie.new(faces)
