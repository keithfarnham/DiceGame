extends Node

enum FaceType
{
	score, #default type, any scoring number value
	multiplier, #adds to multiplier value
	reward, #face is for a reward die, tied to RewardType
	special, #does some special thing
}

enum SpecialType #These faces have do something completely different from scoring/multiplier
{
	reroll = 0, #reroll dice x value times
	choose = 1, #choose a side to land on (cannot choose a choose face)
	removeResult = 2, #remove a die from the roll results
	bomb = 3, #die explodes, no value added
}

enum EffectType #These faces have effects in addition to whatever scoring/multiplier/special
{
	default = 0, #default type, no special
	weighted = 1, #higher chance to land on this face
	dungeonDiceMonster = 2, #die unfurls and //TBD sums value from all faces
	glass = 3, #die destorys itself after scoring
}

enum RewardType
{
	money,
	addDie,
	scoreReroll,
	rewardReroll,
	addRemoveFace,
	plusMinusFaceValue,
	duplicateScoreDie,
	increaseLowestBy3,
	replaceLowestWithHighest
}

#TODO give proper weight values
var RewardTypeWeights = {
	RewardType.money: 				{DiceData.DieRarity.common:1, DiceData.DieRarity.uncommon:2, DiceData.DieRarity.rare:3, DiceData.DieRarity.legendary:4},
	RewardType.addDie:				{DiceData.DieRarity.common:1, DiceData.DieRarity.uncommon:2, DiceData.DieRarity.rare:3, DiceData.DieRarity.legendary:4},
	RewardType.scoreReroll:			{DiceData.DieRarity.common:1, DiceData.DieRarity.uncommon:2, DiceData.DieRarity.rare:3, DiceData.DieRarity.legendary:4},
	RewardType.rewardReroll:		{DiceData.DieRarity.common:1, DiceData.DieRarity.uncommon:2, DiceData.DieRarity.rare:3, DiceData.DieRarity.legendary:4},
	RewardType.addRemoveFace:		{DiceData.DieRarity.common:1, DiceData.DieRarity.uncommon:2, DiceData.DieRarity.rare:3, DiceData.DieRarity.legendary:4},
	RewardType.plusMinusFaceValue:	{DiceData.DieRarity.common:1, DiceData.DieRarity.uncommon:2, DiceData.DieRarity.rare:3, DiceData.DieRarity.legendary:4},
	RewardType.duplicateScoreDie:	{DiceData.DieRarity.common:1, DiceData.DieRarity.uncommon:2, DiceData.DieRarity.rare:3, DiceData.DieRarity.legendary:4},
}
