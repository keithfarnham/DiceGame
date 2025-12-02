#extends Resource?
extends Node

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
	common,
	uncommon,
	rare,
	legendary
}

var DieFaceCountWeight = {
	DieFaceCount.Coin: 	{DieRarity.common:1, DieRarity.uncommon:2, DieRarity.rare:3, DieRarity.legendary:4},
	DieFaceCount.D3: 	{DieRarity.common:2, DieRarity.uncommon:2, DieRarity.rare:3, DieRarity.legendary:4},
	DieFaceCount.D4:	{DieRarity.common:3, DieRarity.uncommon:2, DieRarity.rare:3, DieRarity.legendary:4},
	DieFaceCount.D5: 	{DieRarity.common:5, DieRarity.uncommon:2, DieRarity.rare:3, DieRarity.legendary:4},
	DieFaceCount.D6: 	{DieRarity.common:7, DieRarity.uncommon:2, DieRarity.rare:3, DieRarity.legendary:4},
	DieFaceCount.D8: 	{DieRarity.common:5, DieRarity.uncommon:2, DieRarity.rare:3, DieRarity.legendary:4},
	DieFaceCount.D10: 	{DieRarity.common:4, DieRarity.uncommon:2, DieRarity.rare:3, DieRarity.legendary:4},
	DieFaceCount.D12: 	{DieRarity.common:3, DieRarity.uncommon:2, DieRarity.rare:3, DieRarity.legendary:4},
	DieFaceCount.D16: 	{DieRarity.common:2, DieRarity.uncommon:2, DieRarity.rare:3, DieRarity.legendary:4},
	DieFaceCount.D20: 	{DieRarity.common:1, DieRarity.uncommon:2, DieRarity.rare:3, DieRarity.legendary:4}
}

var DieFaceTypeWeight = {
	DieFaceData.FaceType.score: 		{DieRarity.common:8, DieRarity.uncommon:6, DieRarity.rare:5, DieRarity.legendary:3},
	DieFaceData.FaceType.multiplier: 	{DieRarity.common:2, DieRarity.uncommon:4, DieRarity.rare:5, DieRarity.legendary:7}
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

func make_a_die(numFaces : int, type := MakeADieType.score) -> Die:
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

func simple_reward_D6():
	var faces : Array[DieFace]
	for i in DieFaceCount.D6:
		faces.append(DieFace.new(i + 1, DieFaceData.FaceType.reward))
	return Die.new(faces, DiceType.reward)

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
			print("[DiceData][num_faces] - random num chosen " + str(r) + " for faces from rarity " + str(DieRarity.keys()[rarity]) + " returning numFaces " + str(numFaces))
			return numFaces
		r -= facesWeight
	push_error("ERROR random_num_faces_from_rarity hit something we shouldn't")


func random_score_face_value_from_rarity(numFaces, rarity : DieRarity) -> int:
	#weight of v^p where p depends on rarity, p==0 => uniform distribution
	#might want to change this to make lower rarity have less of a chance to give higher values rather than uniform dist
	var power_map = {
		DieRarity.common: 0.0,
		DieRarity.uncommon: 0.3,
		DieRarity.rare: 0.6,
		DieRarity.legendary: 1.0
	}
	var p = power_map.get(rarity)

	var weights = []
	var total = 0.0
	for v in range(1, int(numFaces) + 1):
		var w = pow(float(v), p)
		weights.append(w)
		total += w

	var r = randf() * total
	for i in range(weights.size()):
		if r < weights[i]:
			var chosen = i + 1
			print("[DiceData][score_face_value] - random float " + str(r) + " total " + str(total) + " rarity " + str(DieRarity.keys()[rarity]) + " returning " + str(chosen))
			return chosen
		r -= weights[i]
		
	return int(numFaces)
	
func random_reward_face_value_from_rarity(rarity : DieRarity):
	#TODO re-enable
	return DieFaceData.RewardType.money
	#var r = randi_range(0, sum_reward_face_weights_for_rarity(rarity))
	#for rewardType in DieFaceData.RewardTypeWeights.keys():
		#print("TESTOUTPUT reward type is " + str(rewardType))
		#var weights = DieFaceData.RewardTypeWeights.get(rewardType as DieFaceData.RewardType)
		#var weightForRarity = weights.get(rarity as DieRarity)
		#if r < weightForRarity:
			#print("[DiceData][reward_face_value] - random num chosen " + str(r) + " from rarity " + str(DieRarity.keys()[rarity]) + " returning " + str(rewardType))
			#return rewardType
		#r -= weightForRarity
	#print("ERROR random_reward_face_value_from_rarity hit something we shouldn't")

func random_face_type_from_rarity(rarity : DieRarity):
	#TODO re-enable
	return randi_range(DieFaceData.FaceType.score, DieFaceData.FaceType.multiplier)
	#var types = [DieFaceData.FaceType.score, DieFaceData.FaceType.multiplier]
	#var sum = sum_face_type_weights_for_rarity(rarity)
	#var r = randi_range(0, sum)
	#for type in types:
		#var weights = DieFaceTypeWeight.get(type)
		#var typeWeight = weights.get(rarity)
		#if r < typeWeight:
			#print("[DiceData][face_type] - random num chosen " + str(r) + "face type for rarity " + str(DieRarity.keys()[rarity]) + " returning " + str(DieFaceData.FaceType.keys()[type]))
			#return type as DieFaceData.FaceType
		#r -= typeWeight
	#print("ERROR random_face_type_from_rarity hit something we shouldn't")

func random_score_die(rarity : DieRarity):
	#TODO re-enable
	var numFaces = random_num_faces_from_rarity(rarity)
	var faces : Array[DieFace] = []
	for i in numFaces:
		var value = random_score_face_value_from_rarity(numFaces, rarity)
		var type = random_face_type_from_rarity(rarity)
		faces.append(DieFace.new(value, type))
	var newDie = Die.new(faces, DiceData.DiceType.score)
	return newDie
	
func random_reward_die(rarity : DieRarity):
	var numFaces = random_num_faces_from_rarity(rarity)
	var faces : Array[DieFace] = []
	for i in numFaces:
		var value = random_reward_face_value_from_rarity(rarity)
		var type = DieFaceData.FaceType.reward
		faces.append(DieFace.new(value, type))
	var newDie = Die.new(faces, DiceData.DiceType.reward)
	return newDie

func generate_draft_score_dice(numOfDice : int) -> Array[Die]:
	var dice : Array[Die] = []
	for i in numOfDice:
		dice.append(random_score_die(DieRarity.common))
	return dice

func generate_draft_reward_dice(numOfDice : int) -> Array[Die]:
	print("Generating Reward Dice")
	var dice : Array[Die] = []
	dice.append(simple_reward_D6())
	dice.append(random_reward_die(DieRarity.common))
	#dice.append(random_reward_die(DieRarity.common))
	return dice

func generate_starting_dice():
	#simple starting dice func
	#this will be expanded to allow different starting dice to be chosen
	PlayerDice.ScoreDice.append(D6())
	PlayerDice.RewardDice.append(simple_reward_D6())

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
