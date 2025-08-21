extends Button

@onready var resultGrid = $"../ResultGridScroll/ResultGrid" as GridContainer

var DieFaceUIScene = preload("res://scenes/DiceFaceUIScene.tscn")

func _pressed():
	print("Rolling reward dice")
	
	PlayerDice.RewardStakes = []
	for die in get_parent().rewardDice:
		var rolledIndex = die.roll()
		PlayerDice.RewardStakes.append(die.faces[rolledIndex])
		var newFaceUIInstance = DieFaceUIScene.instantiate()# as DieFaceUI
		var typeNode = newFaceUIInstance.find_child("FaceTypeValue") as Label
		typeNode.text = str(DieFaceData.FaceType.keys()[die.faces[rolledIndex].type])
		var faceIndexNode = newFaceUIInstance.find_child("FaceIndexValue") as Label
		faceIndexNode.text = str(rolledIndex)
		var valueNode = newFaceUIInstance.find_child("FaceValueValue") as Label
		valueNode.text = str(DieFaceData.RewardTypeValue.keys()[die.faces[rolledIndex].value])
		resultGrid.add_child(newFaceUIInstance)
	
	visible = false
	$"../Continue".visible = true
	$"../ResultStakesText".visible = true
	$"../DiceGridControl".visible = false
	$"../DiceGridLabel".visible = false
