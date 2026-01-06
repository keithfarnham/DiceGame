extends Control

var DieFaceUIScene = preload("res://scenes/DiceFaceUIScene.tscn")

@onready var diceGridLabel = $DiceGridLabel as RichTextLabel
@onready var rollResultGrid = $ScoreRollUI/RollResultGrid as GridContainer
@onready var diceGrid = $DiceGrid as DiceGrid
@onready var sumInfo = $ScoreRollUI/SumInfo as RichTextLabel
@onready var multInfo = $ScoreRollUI/MultInfo as RichTextLabel
@onready var rollButton = $ScoreRollUI/RollButton as Button
@onready var continueButton  = $ScoreRollUI/Continue as Button

var goalValue = PlayerDice.Round * PlayerDice.Round
var gameOver := false

func _ready():
	diceGrid.populate_grid()
	$DiceGrid/DiceTabs.visible = false
	$GoalControl/GoalValue.text = str(goalValue)

func update_text():
	if diceGrid.visible:
		if diceGrid.selectedDie >= 0:
			var dieUI = diceGrid.get_child(diceGrid.selectedDie) as DieUI
			#grabbing focus to prev selected die, see button node's theme overrides for color mod on focus/hover
			dieUI.grab_focus()

func _on_sum_info_area_mouse_entered():
	if $ScoreRollUI/InfoPanel/Instructions.visible:
		$ScoreRollUI/InfoPanel/Instructions.visible = false
	if !sumInfo.visible:
		sumInfo.visible = true
	if !$ScoreRollUI/InfoPanel/SumInfo.visible:
		$ScoreRollUI/InfoPanel/SumInfo.visible = true

func _on_sum_info_area_mouse_exited():
	if sumInfo.visible:
		sumInfo.visible = false
	if $ScoreRollUI/InfoPanel/SumInfo.visible:
		$ScoreRollUI/InfoPanel/SumInfo.visible = false

func _on_mult_info_area_mouse_entered():
	if $ScoreRollUI/InfoPanel/Instructions.visible:
		$ScoreRollUI/InfoPanel/Instructions.visible = false
	if !multInfo.visible:
		multInfo.visible = true
	if !$ScoreRollUI/InfoPanel/MultInfo.visible:
		$ScoreRollUI/InfoPanel/MultInfo.visible = true

func _on_mult_info_area_mouse_exited():
	if multInfo.visible:
		multInfo.visible = false
	if $ScoreRollUI/InfoPanel/MultInfo.visible:
		$ScoreRollUI/InfoPanel/MultInfo.visible = false

func _on_roll_button_pressed():
	Log.print("Rolling Score dice")
	if !rollResultGrid.visible:
		rollResultGrid.visible = true
	if !$ScoreRollUI/InfoPanel.visible:
		$ScoreRollUI/InfoPanel.visible = true
	var totalSum : int
	var preMultSum := 0
	var totalMult := 1
	var index := 0
	#var sumFaces : Array[DieFace] = []
	#var multFaces : Array[DieFace] = []
	sumInfo.text = ""
	multInfo.text = "1"
	for die in PlayerDice.ScoreDice:
		var rolledIndex = die.roll()
		Log.print("rolled index " + str(rolledIndex))
		match die.get_type_for_face(rolledIndex):
			DieFaceData.FaceType.score:
				Log.print("rolling score " + str(die.get_value_for_face(rolledIndex)))
				preMultSum += die.get_value_for_face(rolledIndex)
				if sumInfo.text != "" :
					sumInfo.text += " + "
				sumInfo.text += str(die.get_value_for_face(rolledIndex))
				var faceInstance = DieFaceUIScene.instantiate() as DieFaceUI
				var dieFace = die.get_face(rolledIndex)
				faceInstance.initialize(dieFace, index, false)
				$ScoreRollUI/InfoPanel/SumInfo.add_child(faceInstance)
			DieFaceData.FaceType.multiplier:
				Log.print("rolling mult " + str(die.get_value_for_face(rolledIndex)))
				totalMult += die.get_value_for_face(rolledIndex)
				if multInfo.text != "":
					multInfo.text += " + "
				multInfo.text += str(die.get_value_for_face(rolledIndex))
				var faceInstance = DieFaceUIScene.instantiate() as DieFaceUI
				var dieFace = die.get_face(rolledIndex)
				faceInstance.initialize(dieFace, index, false)
				$ScoreRollUI/InfoPanel/MultInfo.add_child(faceInstance)
			DieFaceData.FaceType.special:
				Log.print("special")
		index += 1
	sumInfo.text += " = " + str(preMultSum)
	multInfo.text += " = " + str(totalMult)
	totalSum = preMultSum * totalMult
	var sumText := rollResultGrid.get_node("RollSum") as RichTextLabel
	sumText.text = str(preMultSum)
	var multText := rollResultGrid.get_node("RollMultValue") as RichTextLabel
	multText.text = str(totalMult)
	var totalText := rollResultGrid.get_node("RollResult") as RichTextLabel
	totalText.text = str(totalSum)
	Log.print("rolled value: " + str(preMultSum) + " * " + str(totalMult) + " = " + str(totalSum))
	rollButton.visible = false
	continueButton.visible = true
	if totalSum < goalValue:
		$GameOver.visible = true
		gameOver = true
		continueButton.text = "Back To Start"
	#TODO replace the DiceGrid being visible with the actual visual of the dice roll results

func _on_continue_pressed():
	if gameOver:
		get_tree().change_scene_to_file("res://scenes/FrontEnd.tscn")
	elif BoardData.bossRound:
		PlayerDice.Round += 1
		get_tree().change_scene_to_file("res://scenes/RewardChoice.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/MoveBoard.tscn")
