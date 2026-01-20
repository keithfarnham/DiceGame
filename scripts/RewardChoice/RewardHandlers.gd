extends Control

class_name RewardHandler

@onready var continueButton = $"../Continue" as Button
@onready var eventText = $"../EventText" as RichTextLabel
@onready var diceGrid = $DiceGrid as DiceGrid

var handlerType : RewardHandlerType
var rewardType

#Vars for specific rewards
var copyPasteFaceIndex

enum RewardHandlerType {
	REWARD_DIE,
	BOARD_EVENT,
	SHOP #might not need
}

func set_reward_type(newType : RewardHandlerType, newReward):
	handlerType = newType
	visible = true
	match handlerType:
		RewardHandlerType.REWARD_DIE:
			rewardType = newReward as DieFaceData.RewardType
			match rewardType:
				DieFaceData.RewardType.ADD_REMOVE_FACE:
					$addRemoveFace.visible = true
					diceGrid.set_type(DiceGrid.GridType.ALL_DICE_FACE_CHOICE)
				DieFaceData.RewardType.PLUS_MINUS_FACE:
					$plusMinusFaceValue.visible = true
					diceGrid.set_type(DiceGrid.GridType.SCORE_FACE_CHOICE)
				DieFaceData.RewardType.DUPE_SCORE_DIE:
					$duplicateDie.visible = true
					diceGrid.set_type(DiceGrid.GridType.SCORE_DIE_CHOICE)
				DieFaceData.RewardType.LOWEST_PLUS_3:
					$lowestPlus.visible = true
					diceGrid.set_type(DiceGrid.GridType.SCORE_DIE_CHOICE)
				DieFaceData.RewardType.REPLACE_LOW_W_HIGH:
					$replaceLowWithHigh.visible = true
					diceGrid.set_type(DiceGrid.GridType.SCORE_DIE_CHOICE)
				DieFaceData.RewardType.COPY_PASTE:
					$copyPaste.visible = true
					diceGrid.set_type(DiceGrid.GridType.ALL_DICE_FACE_CHOICE)
		RewardHandlerType.BOARD_EVENT:
			rewardType = newReward as EventSpace.EventType
			match rewardType:
				EventSpace.EventType.ADD_REMOVE_FACE:
					$addRemoveFace.visible = true
					diceGrid.set_type(DiceGrid.GridType.ALL_DICE_FACE_CHOICE)
				EventSpace.EventType.PLUS_TO_FACE:
					$plusToFace.visible = true
					diceGrid.set_type(DiceGrid.GridType.SCORE_FACE_CHOICE)
		RewardHandlerType.SHOP:
			rewardType = newReward as Shop.ShopOptions

func _ready():
	diceGrid.faceSelected.connect(_face_selected)
	diceGrid.dieSelected.connect(_die_selected)

func _face_selected(faceIndex : int):
	Log.print("[RewardHandler] - face selected at index " + str(faceIndex) + " with handlerType " + str(RewardHandlerType.keys()[handlerType]))
	match handlerType:
		RewardHandlerType.REWARD_DIE:
			Log.print("[RewardHandler] - face selected rewardType " + str(DieFaceData.RewardType.keys()[rewardType]))
			match rewardType:
				DieFaceData.RewardType.ADD_REMOVE_FACE:
					$addRemoveFace/DuplicateFace.disabled = false
					$addRemoveFace/RemoveFace.disabled = false
				DieFaceData.RewardType.PLUS_MINUS_FACE:
					$plusMinusFaceValue/PlusFace.disabled = false
					$plusMinusFaceValue/MinusFace.disabled = false
				DieFaceData.RewardType.COPY_PASTE:
					$copyPaste/CopyPaste.disabled = false
		RewardHandlerType.BOARD_EVENT:
			Log.print("[RewardHandler] - face selected rewardType " + str(EventSpace.EventType.keys()[rewardType]))
			match rewardType:
				EventSpace.EventType.ADD_REMOVE_FACE:
					$addRemoveFace/DuplicateFace.disabled = false
					$addRemoveFace/RemoveFace.disabled = false
				EventSpace.EventType.PLUS_TO_FACE:
					$plusToFace/PlusToFace.disabled = false
		RewardHandlerType.SHOP:
			Log.print("[RewardHandler] - face selected rewardType " + str(Shop.ShopOptions.keys()[rewardType]))
			match rewardType:
				#Shop.ShopOption.ADD_FACE:
				
				Shop.ShopOptions.REMOVE_FACE:
					$removeFace/RemoveFace.disabled = false

func _die_selected(dieIndex : int, isUnselect : bool):
	Log.print("[RewardHandler] - die selected with index " + str(dieIndex))
	match handlerType:
		RewardHandlerType.REWARD_DIE:
			match rewardType:
				DieFaceData.RewardType.ADD_REMOVE_FACE:
					$addRemoveFace/DuplicateFace.disabled = true
					$addRemoveFace/RemoveFace.disabled = true
				DieFaceData.RewardType.PLUS_MINUS_FACE:
					$plusMinusFaceValue/PlusFace.disabled = true
					$plusMinusFaceValue/MinusFace.disabled = true
				DieFaceData.RewardType.DUPE_SCORE_DIE:
					Log.print("dieIndex is " + str(dieIndex) + " and selectedDie is " + str(diceGrid.selectedDie))
					$duplicateDie/DuplicateDie.disabled = true if isUnselect else false
				DieFaceData.RewardType.LOWEST_PLUS_3:
					$lowestPlus/LowestPlus.disabled = true if isUnselect else false
					diceGrid.set_border_style_for_face(PlayerDice.get_score_die_min_face_index(diceGrid.selectedDie), DieFaceUI.StyleBorderType.TARGET)
				DieFaceData.RewardType.REPLACE_LOW_W_HIGH:
					$replaceLowWithHigh/ReplaceLowWithHigh.disabled = false
					diceGrid.set_border_style_for_face(PlayerDice.get_score_die_max_face_index(diceGrid.selectedDie), DieFaceUI.StyleBorderType.SOURCE)
					diceGrid.set_border_style_for_face(PlayerDice.get_score_die_min_face_index(diceGrid.selectedDie), DieFaceUI.StyleBorderType.TARGET)
		RewardHandlerType.BOARD_EVENT:
			match rewardType:
				EventSpace.EventType.ADD_REMOVE_FACE:
					$addRemoveFace/DuplicateFace.disabled = true
					$addRemoveFace/RemoveFace.disabled = true
				EventSpace.EventType.PLUS_TO_FACE:
					$plusToFace/PlusToFace.disabled = true
		RewardHandlerType.SHOP:
			match rewardType:
				Shop.ShopOptions.ADD_FACE:
					$addFace/AddFace.disabled = false if dieIndex != diceGrid.selectedDie else true
				Shop.ShopOptions.REMOVE_FACE:
					$removeFace/RemoveFace.disabled = true

func _handle_reward_chosen_common():
	diceGrid.mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_DISABLED
	diceGrid.mouse_filter = Control.MOUSE_FILTER_IGNORE
	continueButton.visible = true
	eventText.visible = true

func _on_duplicate_face_pressed():
	eventText.text = "Face duplicated"
	match diceGrid.currentTab:
		DiceGrid.GridTabs.SCORE:
			PlayerDice.ScoreDice[diceGrid.selectedDie].faces.append(PlayerDice.ScoreDice[diceGrid.selectedDie].faces[diceGrid.selectedFace])
		DiceGrid.GridTabs.REWARD:
			PlayerDice.RewardDice[diceGrid.selectedDie].faces.append(PlayerDice.RewardDice[diceGrid.selectedDie].faces[diceGrid.selectedFace])
	$addRemoveFace.visible = false
	$addRemoveFace/AddFace.disabled = true
	$addRemoveFace/RemoveFace.disabled = true
	_handle_reward_chosen_common()
	
func _on_add_face_pressed():
	eventText.text = "Random face added"
	match diceGrid.currentTab:
		DiceGrid.GridTabs.SCORE:
			var value = DiceData.random_score_face_value_from_rarity(20, DiceData.DieRarity.COMMON)
			var type = DiceData.random_face_type_from_rarity(DiceData.DieRarity.COMMON)
			PlayerDice.ScoreDice[diceGrid.selectedDie].faces.append(DieFace.new(value, type))
		DiceGrid.GridTabs.REWARD:
			var value = DiceData.random_reward_face_value_from_rarity(DiceData.DieRarity.COMMON)
			var type = DieFaceData.FaceType.REWARD
			PlayerDice.RewardDice[diceGrid.selectedDie].faces.append(DieFace.new(value, type))
	$addFace.visible = false
	$addFace/AddFace.disabled = true
	_handle_reward_chosen_common()


func _on_remove_face_pressed(buttonNode):
	#signal connection must have Append Source in advanced settings enabled to pass the pressed button's node as param
	eventText.text = "Face removed from die"
	match diceGrid.currentTab:
		DiceGrid.GridTabs.SCORE:
			PlayerDice.ScoreDice[diceGrid.selectedDie].faces.remove_at(diceGrid.selectedFace)
		DiceGrid.GridTabs.REWARD:
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
	diceGrid.refresh_face_grid()


func _on_plus_face_pressed(buttonNode):
	eventText.text = "Die face increased by 1"
	PlayerDice.ScoreDice[diceGrid.selectedDie].faces[diceGrid.selectedFace].value += 1
	match buttonNode.get_parent().name: #TODO evaluate if there is a cleaner way to doing this than checking parent name, but this works for now
		"plusMinusFaceValue":
			$plusMinusFaceValue.visible = false
			$plusMinusFaceValue/PlusFace.disabled = true
			$plusMinusFaceValue/MinusFace.disabled = true
		"plusToFace":
			$plusToFace.visible = false
			$plusToFace/PlusToFace.disabled  = true
	_handle_reward_chosen_common()
	diceGrid.refresh_face_grid()


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


func _on_lowest_plus_pressed():
	eventText.text = "+3 to lowest face on selected die"
	PlayerDice.ScoreDice[diceGrid.selectedDie].faces[PlayerDice.get_score_die_min_face_index(diceGrid.selectedDie)].value += 3
	$lowestPlus.visible = false
	_handle_reward_chosen_common()
	diceGrid.refresh_face_grid()

func _on_replace_low_with_high_pressed():
	eventText.text = "Replaced selected die's lowest face with highest face"
	PlayerDice.ScoreDice[diceGrid.selectedDie].faces[PlayerDice.get_score_die_min_face_index(diceGrid.selectedDie)].value = \
		PlayerDice.ScoreDice[diceGrid.selectedDie].faces[PlayerDice.get_score_die_max_face_index(diceGrid.selectedDie)].value
	$replaceLowWithHigh.visible = false
	_handle_reward_chosen_common()
	diceGrid.refresh_face_grid()

func _on_copy_paste_pressed():
	if copyPasteFaceIndex == null:
		eventText.text = "Select a face to replace"
		$copyPaste/CopyPaste.text = "Paste to Face"
		$copyPaste/CopyPaste.disabled = true
		#copy the selected index and disable dice selection
		copyPasteFaceIndex = diceGrid.selectedFace
		diceGrid.toggle_die_grid_focus(false)
		diceGrid.toggle_die_face_focus(copyPasteFaceIndex, false)
	else:
		eventText.text = "Copied face pasted to selected face"
		$copyPaste/CopyPaste.visible = false
		match diceGrid.currentTab:
			DiceGrid.GridTabs.SCORE:
				PlayerDice.ScoreDice[diceGrid.selectedDie].faces[diceGrid.selectedFace] = PlayerDice.ScoreDice[diceGrid.selectedDie].faces[copyPasteFaceIndex]
			DiceGrid.GridTabs.REWARD:
				PlayerDice.RewardDice[diceGrid.selectedFace] = PlayerDice.RewardDice[copyPasteFaceIndex]
		_handle_reward_chosen_common()
		diceGrid.refresh_face_grid()
