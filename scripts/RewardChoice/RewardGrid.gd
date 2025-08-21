extends GridContainer

var DieFaceUIScene = preload("res://scenes/DiceFaceUIScene.tscn")
var ChosenDie

func _ready():
	#populate grid with PlayerDice.RewardStakes faces
	for faceIndex in PlayerDice.RewardStakes.size():
		var newFaceUIInstance = DieFaceUIScene.instantiate() #as DieFaceUI
		var typeNode = newFaceUIInstance.find_child("FaceTypeValue") as Label
		typeNode.text = str(DieFaceData.FaceType.keys()[PlayerDice.RewardStakes[faceIndex].type])
		var faceIndexNode = newFaceUIInstance.find_child("FaceIndexValue") as Label
		faceIndexNode.text = str(faceIndex)
		var valueNode = newFaceUIInstance.find_child("FaceValueValue") as Label
		valueNode.text = str(DieFaceData.RewardTypeValue.keys()[PlayerDice.RewardStakes[faceIndex].value])
		add_child(newFaceUIInstance)
		var buttonNode = newFaceUIInstance.find_child("Button") as DieFaceUI
		buttonNode.connect("pressed", _on_pressed)

func _on_pressed(dieInstance):
	if $"../ChooseDie/ChooseDieButton".visible == false:
		$"../ChooseDie/ChooseDieButton".visible = true
	ChosenDie = dieInstance
	print("pressed a reward die")
