extends Control

@onready var continueButton = $"../Continue" as Button
@onready var eventText = $"../EventText" as RichTextLabel
@onready var diceGrid = $DiceGrid as DiceGrid

var type : RewardType

#setting up another enum here in case I want the DieFace rewards and MoveBoard items to have different effects
#though in the end it probably end up being cleaner to have one unifying enum, I'm still not 100% on board items/die rewards having overlap
#TODO re-evaluate
enum RewardType {
	addRemoveFace,
	plusMinusFace,
	duplicateDie
}

func set_reward_type(newType : RewardType):
	type = newType

func _ready():
	diceGrid.faceSelected.connect(_face_selected)
	diceGrid.dieSelected.connect(_die_selected)

func _face_selected(faceIndex : int):
	print("[RewardHandler] - face selected with index " + str(faceIndex))
	match type:
		RewardType.addRemoveFace:
			#if diceGrid.selectedFace == faceIndex:
				#$addRemoveFace/AddFace.disabled = true
				#$addRemoveFace/RemoveFace.disabled = true
			#else:
			$addRemoveFace/AddFace.disabled = false
			$addRemoveFace/RemoveFace.disabled = false

func _die_selected(dieIndex : int):
	print("[RewardHandler] - die selected with index " + str(dieIndex))
	match type:
		RewardType.addRemoveFace:
			$addRemoveFace/AddFace.disabled = true
			$addRemoveFace/RemoveFace.disabled = true

func _on_add_face_pressed():
	eventText.text = "Face added to die"
	match diceGrid.currentTab:
		DiceGrid.GridTabs.score:
			#TODO generate a random face or something - this just duplicates the selected face for now
			PlayerDice.ScoreDice[diceGrid.selectedDie].faces.append(PlayerDice.ScoreDice[diceGrid.selectedDie].faces[diceGrid.selectedFace])
		DiceGrid.GridTabs.reward:
			PlayerDice.RewardDice[diceGrid.selectedDie].faces.append(PlayerDice.RewardDice[diceGrid.selectedDie].faces[diceGrid.selectedFace])
	$addRemoveFace.visible = false
	$addRemoveFace/AddFace.disabled = true
	$addRemoveFace/RemoveFace.disabled = true
	diceGrid.mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_DISABLED
	diceGrid.mouse_filter = Control.MOUSE_FILTER_IGNORE
	continueButton.visible = true
	eventText.visible = true


func _on_remove_face_pressed():
	eventText.text = "Face removed from die"
	match diceGrid.currentTab:
		DiceGrid.GridTabs.score:
			PlayerDice.ScoreDice[diceGrid.selectedDie].faces.remove_at(diceGrid.selectedFace)
		DiceGrid.GridTabs.reward:
			PlayerDice.RewardDice[diceGrid.selectedDie].faces.remove_at(diceGrid.selectedFace)
	$addRemoveFace.visible = false
	$addRemoveFace/AddFace.disabled = true
	$addRemoveFace/RemoveFace.disabled = true
	diceGrid.mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_DISABLED
	diceGrid.mouse_filter = Control.MOUSE_FILTER_IGNORE
	continueButton.visible = true
	eventText.visible = true


func _on_plus_face_pressed():
	eventText.text = "Die face increased by 1"
	PlayerDice.ScoreDice[diceGrid.selectedDie].faces[diceGrid.selectedFace].value += 1
	$plusMinusFaceValue.visible = false
	diceGrid.mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_DISABLED
	diceGrid.mouse_filter = Control.MOUSE_FILTER_IGNORE
	continueButton.visible = true
	eventText.visible = true


func _on_minus_face_pressed():
	eventText.text = "Die face reduced by 1"
	PlayerDice.ScoreDice[diceGrid.selectedDie].faces[diceGrid.selectedFace].value -= 1
	$plusMinusFaceValue.visible = false
	diceGrid.mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_DISABLED
	diceGrid.mouse_filter = Control.MOUSE_FILTER_IGNORE
	continueButton.visible = true
	eventText.visible = true


func _on_duplicate_die_pressed():
	eventText.text = "Duplicated selected die"
	#TODO this duplicates the instance, but i need to create a new instance with the same values and append that instead
	#same for the face duplicate as well
	PlayerDice.ScoreDice.append(PlayerDice.ScoreDice[diceGrid.selectedDie])
	$duplicateDie.visible = false
	diceGrid.mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_DISABLED
	diceGrid.mouse_filter = Control.MOUSE_FILTER_IGNORE
	continueButton.visible = true
	eventText.visible = true
