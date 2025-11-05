extends Control

@onready var diceGridLabel = $DiceGridLabel as RichTextLabel
@onready var rollResultGrid = $ScoreRollUI/RollResultGrid as GridContainer
@onready var diceGrid = $DiceGrid as DiceGrid
@onready var sumInfo = $ScoreRollUI/SumInfo as RichTextLabel
@onready var multInfo = $ScoreRollUI/MultInfo as RichTextLabel
@onready var rollButton = $ScoreRollUI/RollButton as Button
@onready var continueButton  = $ScoreRollUI/Continue as Button

func update_text():
	if diceGrid.visible:
		if diceGrid.selectedDie >= 0:
			var dieUI = diceGrid.get_child(diceGrid.selectedDie) as DieUI
			#grabbing focus to prev selected die, see button node's theme overrides for color mod on focus/hover
			dieUI.grab_focus()

func _on_sum_info_area_mouse_entered():
	if !sumInfo.visible:
		sumInfo.visible = true

func _on_sum_info_area_mouse_exited():
	if sumInfo.visible:
		sumInfo.visible = false

func _on_mult_info_area_mouse_entered():
	if !multInfo.visible:
		multInfo.visible = true

func _on_mult_info_area_mouse_exited():
	if multInfo.visible:
		multInfo.visible = false

func _on_roll_button_pressed():
	print("Rolling Score dice")
	if !rollResultGrid.visible:
		rollResultGrid.visible = true
	var totalSum : int
	var preMultSum := 0
	var totalMult := 0
	sumInfo.text = ""
	multInfo.text = ""
	for die in PlayerDice.ScoreDice:
		var rolledIndex = die.roll()
		print("rolled index " + str(rolledIndex))
		match die.get_type_for_face(rolledIndex):
			DieFaceData.FaceType.score:
				print("rolling score " + str(die.get_value_for_face(rolledIndex)))
				preMultSum += die.get_value_for_face(rolledIndex)
				if sumInfo.text != "" :
					sumInfo.text += " + "
				sumInfo.text += str(die.get_value_for_face(rolledIndex))
			DieFaceData.FaceType.multiplier:
				print("rolling mult " + str(die.get_value_for_face(rolledIndex)))
				totalMult += die.get_value_for_face(rolledIndex)
				if multInfo.text != "":
					multInfo.text += " + "
				multInfo.text += str(die.get_value_for_face(rolledIndex))
			DieFaceData.FaceType.special:
				print("special")
				
	sumInfo.text += " = " + str(preMultSum)
	multInfo.text += " = " + str(totalMult)
	totalSum = preMultSum * totalMult
	var sumText := rollResultGrid.get_node("RollSum") as RichTextLabel
	sumText.text = str(preMultSum)
	var multText := rollResultGrid.get_node("RollMultValue") as RichTextLabel
	multText.text = str(totalMult)
	var totalText := rollResultGrid.get_node("RollResult") as RichTextLabel
	totalText.text = str(totalSum)
	print("rolled value: " + str(preMultSum) + " * " + str(totalMult) + " = " + str(totalSum))
	rollButton.visible = false
	continueButton.visible = true
	#TODO replace the DiceGrid being visible with the actual visual of the dice roll results

func _on_continue_pressed():
	get_tree().change_scene_to_file("res://scenes/RewardChoice.tscn")
