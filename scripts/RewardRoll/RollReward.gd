extends Control
@onready var diceGrid = $DiceGrid as DiceGrid
@onready var debugControls = $DebugControls as Control
@onready var resultGrid = $ResultGridScroll/ResultGrid as GridContainer

var dieUIScene = preload("res://scenes/DieUIScene.tscn")
var dieFaceUIScene = preload("res://scenes/DiceFaceUIScene.tscn")
var prevSelect := -1

#func _ready():
	#generate result dice and populate DiceGrid
	#diceGrid.add_dice(PlayerDice.RewardDice)
	#debugControls.get_node('DebugUI/PrintDiceArray').debug_print.connect(debug_print)

func _on_roll_pressed():
	print("[RollReward] Rolling reward dice")
	
	PlayerDice.RewardStakes = []
	for die in PlayerDice.RewardDice:
		var rolledIndex = die.roll()
		PlayerDice.RewardStakes.append(die.faces[rolledIndex])
		var newFaceUIInstance = dieFaceUIScene.instantiate()# as DieFaceUI
		var typeNode = newFaceUIInstance.find_child("FaceTypeValue") as Label
		typeNode.text = str(DieFaceData.FaceType.keys()[die.faces[rolledIndex].type])
		var faceIndexNode = newFaceUIInstance.find_child("FaceIndexValue") as Label
		faceIndexNode.text = str(rolledIndex)
		var valueNode = newFaceUIInstance.find_child("FaceValueValue") as Label
		valueNode.text = str(DieFaceData.RewardType.keys()[die.faces[rolledIndex].value])
		resultGrid.add_child(newFaceUIInstance)
	
	$Roll.visible = false
	$Continue.visible = true
	$ResultStakesText.visible = true
	diceGrid.visible = false
	$DiceGridLabel.visible = false


func _on_continue_pressed():
	get_tree().change_scene_to_file("res://scenes/RollScore.tscn")
