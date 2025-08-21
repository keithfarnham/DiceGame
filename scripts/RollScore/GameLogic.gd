extends Control

#@onready var diceBag  = $DiceBag as DiceBag

func _ready():
	#setup starting dice
	#diceBag.add_dice(DiceData.StartingDice())
	PlayerDice.add_dice(DiceData.StartingDice())
	pass
