extends Node

class_name PlayerClass

enum ClassChoice
{
	StandardGambler,
	DungeonMaster
}

static func get_class_name(pickedClass : ClassChoice):
	var name := ""
	match pickedClass:
		ClassChoice.StandardGambler:
			name = "The Standard Gambler"
		ClassChoice.DungeonMaster:
			name = "The Dungeon Master"
	return name

static func get_class_features(pickedClass : ClassChoice):
	var info := ""
	match pickedClass:
		ClassChoice.StandardGambler:
			info = "The Standard Gambler is the master of the 6 sided die. Starting draft consists of all D6."
		ClassChoice.DungeonMaster:
			info = "The Dungeon Master loves table top games and prefers the 20 sided die. Starting draft only has D20."
	return info

static func get_class_dice_draft(pickedClass : ClassChoice):
	pass
