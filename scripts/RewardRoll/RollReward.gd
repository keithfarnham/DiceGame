extends Control

@onready var diceGrid = $DiceGrid as DiceGrid
@onready var debugControls = $DebugControls as Control
@onready var resultGrid = $ResultGridScroll/ResultGrid as GridContainer

var dieUIScene = preload("res://scenes/DieUIScene.tscn")
var dieFaceUIScene = preload("res://scenes/DiceFaceUIScene.tscn")
var prevSelect := -1

func _on_roll_pressed():
	print("[RollReward] Rolling reward dice")
	PlayerDice.RewardStakes = []
	for die in PlayerDice.RewardDice:
		var rolledIndex = die.roll()
		PlayerDice.RewardStakes.append(die.faces[rolledIndex])
		var newFaceUIInstance = dieFaceUIScene.instantiate() as DieFaceUI
		var type = die.faces[rolledIndex].type
		var value = die.faces[rolledIndex].value
		var dieFace = DieFace.new(value, type)
		var enableFocus = false
		newFaceUIInstance.initialize(dieFace, rolledIndex, enableFocus)
		resultGrid.add_child(newFaceUIInstance)
	
	$Roll.visible = false
	$Continue.visible = true
	$ResultStakesText.visible = true
	diceGrid.visible = false
	$DiceGridLabel.visible = false

func _on_continue_pressed():
	get_tree().change_scene_to_file("res://scenes/RollScore.tscn")
