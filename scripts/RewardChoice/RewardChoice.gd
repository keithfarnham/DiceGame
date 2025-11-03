extends Control

@onready var rewardGrid = $RewardGrid as GridContainer
@onready var chooseDieButton = $ChooseDie/ChooseDieButton as Button
@onready var chooseDieConfirm = $ChooseDie/ChooseDieConfirm as ConfirmationDialog

var DieFaceUIScene = preload("res://scenes/DiceFaceUIScene.tscn")
var ChosenReward : DieFaceData.RewardType

func _ready():
	#populate grid with PlayerDice.RewardStakes faces
	for faceIndex in PlayerDice.RewardStakes.size():
		var newFaceUIInstance = DieFaceUIScene.instantiate() as DieFaceUI
		var typeNode = newFaceUIInstance.find_child("FaceTypeValue") as Label
		typeNode.text = str(DieFaceData.FaceType.keys()[PlayerDice.RewardStakes[faceIndex].type])
		var faceIndexNode = newFaceUIInstance.find_child("FaceIndexValue") as Label
		faceIndexNode.text = str(faceIndex)
		var valueNode = newFaceUIInstance.find_child("FaceValueValue") as Label
		valueNode.text = str(DieFaceData.RewardType.keys()[PlayerDice.RewardStakes[faceIndex].value])
		rewardGrid.add_child(newFaceUIInstance)
		#var buttonNode = newFaceUIInstance.find_child("Button") as DieFaceUI
		newFaceUIInstance.dieFaceData = PlayerDice.RewardStakes[faceIndex]
		newFaceUIInstance.disabled = false
		newFaceUIInstance.focus_mode = Control.FOCUS_CLICK
		newFaceUIInstance.connect("faceSelected", _on_pressed)

func handle_rewards(chosenReward : DieFaceData.RewardType):
	match chosenReward:
		DieFaceData.RewardType.money:
			#TODO make this variable based on value rolled or level
			PlayerDice.Money += 10
		DieFaceData.RewardType.addDie:
			var newDie = DiceData.MakeADie(6)
			PlayerDice.add_die(newDie)
		DieFaceData.RewardType.scoreReroll:
			PlayerDice.RerollScore += 1
		DieFaceData.RewardType.rewardReroll:
			PlayerDice.RerollReward += 1
		#DieFaceData.RewardType.upgradeDieValue:
		#DieFaceData.RewardType.addRemoveFace:
		#DieFaceData.RewardType.plusMinusFaceValue:
		#DieFaceData.RewardType.duplicateDie:
		

func _on_pressed(rewardType : DieFaceData.RewardType):
	if chooseDieButton.visible == false:
		chooseDieButton.visible = true
	ChosenReward = rewardType

func _on_choose_die_button_pressed():
	chooseDieButton.visible = false
	chooseDieConfirm.visible = true

func _on_choose_die_confirm_confirmed():
	print("[RewardChoice] chosen reward is " + str(DieFaceData.RewardType.keys()[ChosenReward]))
	handle_rewards(ChosenReward)
	get_tree().change_scene_to_file("res://scenes/RollReward.tscn")
	#TODO handle whatever the reward choice outcome is - should this be a separate scene? 

func _on_choose_die_confirm_canceled():
	chooseDieConfirm.visible = false
	chooseDieButton.visible = true
