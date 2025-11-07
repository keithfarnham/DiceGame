extends Control

@onready var continueButton = $"../Continue" as Button
@onready var rewardText = $"../Continue/ContinueLabel" as RichTextLabel
@onready var diceGrid = $DiceGrid as DiceGrid

func _on_add_face_pressed():
	rewardText.text = "Face added to die"
	match diceGrid.currentTab:
		DiceGrid.GridTabs.score:
			#TODO generate a random face or something - this just duplicates the selected face for now
			PlayerDice.ScoreDice[diceGrid.selectedDie].faces.append(PlayerDice.ScoreDice[diceGrid.selectedDie].faces[diceGrid.selectedFace])
		DiceGrid.GridTabs.reward:
			PlayerDice.RewardDice[diceGrid.selectedDie].faces.append(PlayerDice.RewardDice[diceGrid.selectedDie].faces[diceGrid.selectedFace])
	$addRemoveFace.visible = false
	diceGrid.mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_DISABLED
	diceGrid.mouse_filter = Control.MOUSE_FILTER_IGNORE
	continueButton.visible = true


func _on_remove_face_pressed():
	rewardText.text = "Face removed from die"
	match diceGrid.currentTab:
		DiceGrid.GridTabs.score:
			PlayerDice.ScoreDice[diceGrid.selectedDie].faces.remove_at(diceGrid.selectedFace)
		DiceGrid.GridTabs.reward:
			PlayerDice.RewardDice[diceGrid.selectedDie].faces.remove_at(diceGrid.selectedFace)
	$addRemoveFace.visible = false
	diceGrid.mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_DISABLED
	diceGrid.mouse_filter = Control.MOUSE_FILTER_IGNORE
	continueButton.visible = true


func _on_plus_face_pressed():
	rewardText.text = "Die face increased by 1"
	PlayerDice.ScoreDice[diceGrid.selectedDie].faces[diceGrid.selectedFace].value += 1
	$plusMinusFaceValue.visible = false
	diceGrid.mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_DISABLED
	diceGrid.mouse_filter = Control.MOUSE_FILTER_IGNORE
	continueButton.visible = true


func _on_minus_face_pressed():
	rewardText.text = "Die face reduced by 1"
	PlayerDice.ScoreDice[diceGrid.selectedDie].faces[diceGrid.selectedFace].value -= 1
	$plusMinusFaceValue.visible = false
	diceGrid.mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_DISABLED
	diceGrid.mouse_filter = Control.MOUSE_FILTER_IGNORE
	continueButton.visible = true


func _on_duplicate_die_pressed():
	rewardText.text = "Duplicated selected die"
	#TODO this duplicates the instance, but i need to create a new instance with the same values and append that instead
	#same for the face duplicate as well
	PlayerDice.ScoreDice.append(PlayerDice.ScoreDice[diceGrid.selectedDie])
	$duplicateDie.visible = false
	diceGrid.mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_DISABLED
	diceGrid.mouse_filter = Control.MOUSE_FILTER_IGNORE
	continueButton.visible = true
