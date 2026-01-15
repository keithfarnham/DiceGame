extends Node

class_name DieFaceData

enum FaceType
{
	SCORE, #default type, any scoring number value
	MULTIPLIER, #adds to multiplier value
	REWARD, #face is for a reward die, tied to RewardType
	SPECIAL, #does some special thing
}

#TODO setup special and effects
enum SpecialType #These faces do something completely different from scoring/multiplier
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
	MONEY,
	ADD_DIE,
#	scoreReroll,
#	rewardReroll,
	ADD_REMOVE_FACE,
	PLUS_MINUS_FACE,
	DUPE_SCORE_DIE,
	LOWEST_PLUS_3,
	REPLACE_LOW_W_HIGH,
	COPY_PASTE
}

#TODO give proper weight values
static var RewardTypeWeights = {
	RewardType.MONEY: 				{DiceData.DieRarity.COMMON:1, DiceData.DieRarity.UNCOMMON:2, DiceData.DieRarity.RARE:3, DiceData.DieRarity.LEGENDARY:4},
	RewardType.ADD_DIE:				{DiceData.DieRarity.COMMON:1, DiceData.DieRarity.UNCOMMON:2, DiceData.DieRarity.RARE:3, DiceData.DieRarity.LEGENDARY:4},
#	RewardType.scoreReroll:			{DiceData.DieRarity.COMMON:1, DiceData.DieRarity.UNCOMMON:2, DiceData.DieRarity.RARE:3, DiceData.DieRarity.LEGENDARY:4},
#	RewardType.rewardReroll:		{DiceData.DieRarity.COMMON:1, DiceData.DieRarity.UNCOMMON:2, DiceData.DieRarity.RARE:3, DiceData.DieRarity.LEGENDARY:4},
	RewardType.ADD_REMOVE_FACE:		{DiceData.DieRarity.COMMON:1, DiceData.DieRarity.UNCOMMON:2, DiceData.DieRarity.RARE:3, DiceData.DieRarity.LEGENDARY:4},
	RewardType.PLUS_MINUS_FACE:		{DiceData.DieRarity.COMMON:1, DiceData.DieRarity.UNCOMMON:2, DiceData.DieRarity.RARE:3, DiceData.DieRarity.LEGENDARY:4},
	RewardType.DUPE_SCORE_DIE:		{DiceData.DieRarity.COMMON:1, DiceData.DieRarity.UNCOMMON:2, DiceData.DieRarity.RARE:3, DiceData.DieRarity.LEGENDARY:4},
	RewardType.LOWEST_PLUS_3:		{DiceData.DieRarity.COMMON:1, DiceData.DieRarity.UNCOMMON:2, DiceData.DieRarity.RARE:3, DiceData.DieRarity.LEGENDARY:4},
	RewardType.REPLACE_LOW_W_HIGH:	{DiceData.DieRarity.COMMON:1, DiceData.DieRarity.UNCOMMON:2, DiceData.DieRarity.RARE:3, DiceData.DieRarity.LEGENDARY:4},
	RewardType.COPY_PASTE:			{DiceData.DieRarity.COMMON:1, DiceData.DieRarity.UNCOMMON:2, DiceData.DieRarity.RARE:3, DiceData.DieRarity.LEGENDARY:4}
}

static func get_reward_name(type : RewardType) -> String:
	var name = ""
	match type:
		RewardType.MONEY:
			name =  "Money"
		RewardType.ADD_DIE:
			name = "Add Die"
		RewardType.ADD_REMOVE_FACE:
			name = "Add/Remove Face"
		RewardType.PLUS_MINUS_FACE:
			name = "Plus/Minus Face Value"
		RewardType.DUPE_SCORE_DIE:
			name = "Duplicate Score Die"
		RewardType.LOWEST_PLUS_3:
			name = "Lowest Value +3"
		RewardType.REPLACE_LOW_W_HIGH:
			name = "Replace Lowest With Highest"
		RewardType.COPY_PASTE:
			name = "Copy/Paste Face"
	return name
