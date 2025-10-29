extends Node

enum FaceType
{
	score = 0, #default type, any scoring number value
	multiplier = 1, #adds to multiplier value
	special = 2, #does some special thing
	reward = 3 #face is for a reward die, tied to RewardType
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

enum RewardTypeValue
{
	money = 0,
	addDie = 1,
	scoreReroll = 2,
	rewardReroll = 3,
	upgradeDieValue = 4,
	addRemoveFace = 5,
	duplicateDie = 6
}
