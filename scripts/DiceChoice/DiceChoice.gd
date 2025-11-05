extends Control

@onready var choiceLabel = $DiceGridLabel as RichTextLabel
@onready var diceGrid = $DiceGridScroll/DiceGrid as GridContainer
@onready var choiceConfirm = $ChooseDie/ChooseDieConfirm as ConfirmationDialog
@onready var rewardGrid = $RewardGrid as GridContainer

var DieFaceUIScene = preload("res://scenes/DiceFaceUIScene.tscn")
var ChosenDie : Die

#this is a more generic dice choice than the RewardChoice stuff, for choosing an entire die 
#not currently used

func _ready():
	#populate diceGrid with PlayerDice.RewardStakes faces
	for faceIndex in PlayerDice.RewardStakes.size():
		var newFaceUIInstance = DieFaceUIScene.instantiate() #as DieFaceUI
		var typeNode = newFaceUIInstance.find_child("FaceTypeValue") as Label
		typeNode.text = str(DieFaceData.FaceType.keys()[PlayerDice.RewardStakes[faceIndex].type])
		var faceIndexNode = newFaceUIInstance.find_child("FaceIndexValue") as Label
		faceIndexNode.text = str(faceIndex)
		var valueNode = newFaceUIInstance.find_child("FaceValueValue") as Label
		valueNode.text = str(DieFaceData.RewardType.keys()[PlayerDice.RewardStakes[faceIndex].value])
		add_child(newFaceUIInstance)
		var buttonNode = newFaceUIInstance.find_child("Button") as DieFaceUI
		buttonNode.connect("pressed", _on_face_pressed)

func _on_face_pressed(dieInstance):
	if $"../ChooseDie/ChooseDieButton".visible == false:
		$"../ChooseDie/ChooseDieButton".visible = true
	ChosenDie = dieInstance
	print("pressed a reward die")

func _on_choose_die_button_pressed():
	choiceConfirm.visible = true

func _on_choose_die_confirm_canceled():
	choiceConfirm.visible = false

func _on_choose_die_confirm_confirmed():
	print("[DiceChoice] Chose reward die + " + str(rewardGrid.ChosenDie.find_child("FaceIndexValue")))
	rewardGrid.ChosenDie
	print("[DiceChoice] Switching Scene to RollScore")
	get_tree().change_scene_to_file("res://scenes/RollScore.tscn")
