extends Node

class_name PlayerClass

enum ClassChoice
{
	StandardGambler,
	DungeonMaster,
	DiceLover,
	DEBUG_REWARD_CLASS
}

static func get_class_num_reward_dice_draft(pickedClass : ClassChoice):
	var numRewardDice
	match pickedClass:
		ClassChoice.DEBUG_REWARD_CLASS:
			numRewardDice = DieFaceData.RewardType.size()
		_: 
			numRewardDice = 2
	return numRewardDice

static func get_class_name(pickedClass : ClassChoice):
	var name := ""
	match pickedClass:
		ClassChoice.StandardGambler:
			name = "The Standard Gambler"
		ClassChoice.DungeonMaster:
			name = "The Dungeon Master"
		ClassChoice.DiceLover:
			name = "The Dice Lover"
	return name

static func get_class_features(pickedClass : ClassChoice):
	var info := ""
	match pickedClass:
		ClassChoice.StandardGambler:
			info = "The Standard Gambler is the master of the 6 sided die. Starts with a standard D6. Starting draft consists of all D6."
		ClassChoice.DungeonMaster:
			info = "The Dungeon Master enjoys table top role playing games and prefers the 20 sided die. Starts with a standard D20. Starting draft only has D20."
		ClassChoice.DiceLover:
			info = "The Dice Lover loves any and all dice. Starts with random dice. Starting draft has entirely random dice."
	return info
