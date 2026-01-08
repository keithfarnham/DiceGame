extends Control

class_name RewardHandler

@onready var continueButton = $"../Continue" as Button
@onready var eventText = $"../EventText" as RichTextLabel
@onready var diceGrid = $DiceGrid as DiceGrid

var type : RewardType

#setting up another enum here in case I want the DieFace rewards and MoveBoard events to have different effects
#though in the end it probably end up being cleaner to have one unifying enum, I'm still not 100% on board events/die rewards having overlap
#TODO re-evaluate
enum RewardType {
	addRemoveFace,
	plusMinusFace,
	duplicateDie,
	addFace,
	removeFace
}

func set_reward_type(newType : RewardType):
	type = newType

func _ready():
	diceGrid.faceSelected.connect(_face_selected)
	diceGrid.dieSelected.connect(_die_selected)

func _face_selected(faceIndex : int):
	Log.print("[RewardHandler] - face selected with index " + str(faceIndex))
	match type:
		RewardType.addRemoveFace:
			#if diceGrid.selectedFace == faceIndex:
				#$addRemoveFace/AddFace.disabled = true
				#$addRemoveFace/RemoveFace.disabled = true
			#else:
			$addRemoveFace/DuplicateFace.disabled = false
			$addRemoveFace/RemoveFace.disabled = false
		RewardType.plusMinusFace:
			$plusMinusFaceValue/PlusFace.disabled = false
			$plusMinusFaceValue/MinusFace.disabled = false
		RewardType.removeFace:
			$removeFace/RemoveFace.disabled = false

func _die_selected(dieIndex : int):
	Log.print("[RewardHandler] - die selected with index " + str(dieIndex))
	match type:
		RewardType.addRemoveFace:
			$addRemoveFace/DuplicateFace.disabled = true
			$addRemoveFace/RemoveFace.disabled = true
		RewardType.plusMinusFace:
			$plusMinusFaceValue/PlusFace.disabled = true
			$plusMinusFaceValue/MinusFace.disabled = true
		RewardType.duplicateDie:
			$duplicateDie/DuplicateDie.disabled = false
		RewardType.addFace:
			$addFace/AddFace.disabled = false
		RewardType.removeFace:
			$removeFace/RemoveFace.disabled = true

func _handle_reward_chosen_common():
	diceGrid.mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_DISABLED
	diceGrid.mouse_filter = Control.MOUSE_FILTER_IGNORE
	continueButton.visible = true
	eventText.visible = true

func _on_duplicate_face_pressed():
	eventText.text = "Face duplicated"
	match diceGrid.currentTab:
		DiceGrid.GridTabs.score:
			PlayerDice.ScoreDice[diceGrid.selectedDie].faces.append(PlayerDice.ScoreDice[diceGrid.selectedDie].faces[diceGrid.selectedFace])
		DiceGrid.GridTabs.reward:
			PlayerDice.RewardDice[diceGrid.selectedDie].faces.append(PlayerDice.RewardDice[diceGrid.selectedDie].faces[diceGrid.selectedFace])
	$addRemoveFace.visible = false
	$addRemoveFace/AddFace.disabled = true
	$addRemoveFace/RemoveFace.disabled = true
	_handle_reward_chosen_common()
	
func _on_add_face_pressed():
	eventText.text = "Random face added"
	match diceGrid.currentTab:
		DiceGrid.GridTabs.score:
			var value = DiceData.random_score_face_value_from_rarity(20, DiceData.DieRarity.common)
			var type = DiceData.random_face_type_from_rarity(DiceData.DieRarity.common)
			PlayerDice.ScoreDice[diceGrid.selectedDie].faces.append(DieFace.new(value, type))
		DiceGrid.GridTabs.reward:
			var value = DiceData.random_reward_face_value_from_rarity(DiceData.DieRarity.common)
			var type = DieFaceData.FaceType.reward
			PlayerDice.RewardDice[diceGrid.selectedDie].faces.append(DieFace.new(value, type))
	$addFace.visible = false
	$addFace/AddFace.disabled = true
	_handle_reward_chosen_common()


func _on_remove_face_pressed(buttonNode):
	eventText.text = "Face removed from die"
	match diceGrid.currentTab:
		DiceGrid.GridTabs.score:
			PlayerDice.ScoreDice[diceGrid.selectedDie].faces.remove_at(diceGrid.selectedFace)
		DiceGrid.GridTabs.reward:
			PlayerDice.RewardDice[diceGrid.selectedDie].faces.remove_at(diceGrid.selectedFace)
	match buttonNode.get_parent().name: #TODO evaluate if there is a cleaner way to doing this than checking parent name, but this works for now
		"addRemoveFace":
			$addRemoveFace.visible = false
			$addRemoveFace/DuplicateFace.disabled = true
			$addRemoveFace/RemoveFace.disabled = true
		"removeFace":
			$removeFace.visible = false
			$removeFace/RemoveFace.disabled  = true
	_handle_reward_chosen_common()


func _on_plus_face_pressed():
	eventText.text = "Die face increased by 1"
	PlayerDice.ScoreDice[diceGrid.selectedDie].faces[diceGrid.selectedFace].value += 1
	$plusMinusFaceValue.visible = false
	_handle_reward_chosen_common()


func _on_minus_face_pressed():
	eventText.text = "Die face reduced by 1"
	PlayerDice.ScoreDice[diceGrid.selectedDie].faces[diceGrid.selectedFace].value -= 1
	$plusMinusFaceValue.visible = false
	_handle_reward_chosen_common()


func _on_duplicate_die_pressed():
	eventText.text = "Duplicated selected die"
	#TODO this duplicates the instance, but i need to create a new instance with the same values and append that instead
	#same for the face duplicate as well
	PlayerDice.ScoreDice.append(PlayerDice.ScoreDice[diceGrid.selectedDie])
	$duplicateDie.visible = false
	_handle_reward_chosen_common()
