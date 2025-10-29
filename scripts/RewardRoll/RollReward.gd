extends Control
#@onready var diceGrid = $DiceUI/DiceGridScroll/DiceGrid as DiceGrid
#@onready var diceGrid = $DiceGrid/DiceGridContainer/Panel/AspectRatioContainer/HBoxContainer/DiceScrollContainer/DiceGrid as DiceGrid
@onready var diceGrid = $DiceGrid as DiceGrid
@onready var faceGrid = $DiceGrid/DiceGridContainer/Panel/AspectRatioContainer/HBoxContainer/FaceScrollContainer/FaceGrid as GridContainer
@onready var debugControls = $DebugControls as Control
@onready var resultGrid = $ResultGridScroll/ResultGrid as GridContainer

var dieUIScene = preload("res://scenes/DieUIScene.tscn")
var dieFaceUIScene = preload("res://scenes/DiceFaceUIScene.tscn")
#var rewardDice : Array[Die] = []
var prevSelect := -1

#func _ready():
	#generate result dice and populate DiceGrid
	#diceGrid.add_dice(PlayerDice.RewardDice)
	#debugControls.get_node('DebugUI/PrintDiceArray').debug_print.connect(debug_print)

#func debug_print():
	#var string = ""
	#for dieIndex in rewardDice.size():
		#var numFaces = rewardDice[dieIndex].faces.size()
		#string += "\n[u]Reward Die " + str(dieIndex) + " w/ " + str(numFaces) + " faces: [/u]"
		#for faceIndex in rewardDice[dieIndex].faces.size():
			#match rewardDice[dieIndex].faces[faceIndex].type:
				#DieFaceData.FaceType.reward:
					#string += "[b]"
			#string += "[" + str(rewardDice[dieIndex].faces[faceIndex].value) + "]"
			#match rewardDice[dieIndex].faces[faceIndex].type:
				#DieFaceData.FaceType.reward:
					#string += "[/b]"
	#print_rich(string)

	#TODO setup DiceGrid in the RollReward scene
	
	#for dieIndex in rewardDice.size():
		##setting up instance of DieUI
		#var newDieUIInstance = dieUIScene.instantiate() as DieUI
		#var numFacesNode = newDieUIInstance.find_child("NumFaces") as RichTextLabel
		#numFacesNode.text = str(rewardDice[dieIndex].num_faces())
		#var dieIndexNode = newDieUIInstance.find_child("DieIndex") as RichTextLabel
		#dieIndexNode.text = str(dieIndex)
		#var dieTypeNode = newDieUIInstance.find_child("DieType") as RichTextLabel
		#dieTypeNode.text = str("Reward")
		#newDieUIInstance.dieSelected.connect(die_selected)
		#diceGrid.add_child(newDieUIInstance)

#func die_selected(selectedDieIndex : int):
	#print("die_selected prev selected " + str(prevSelect) + " with die index " + str(selectedDieIndex))
	##selectedDieUpdate.emit(dieIndex)
	#if prevSelect == selectedDieIndex and faceGrid.visible:
		##hide face UI and unfocus if reselecting the previously selected die
		#faceGrid.visible = false
		#diceGrid.get_child(selectedDieIndex).release_focus()
	#else:
		#faceGrid.visible = true
		#
	#prevSelect = selectedDieIndex
	#clear_die_face_grid()
	#for faceIndex in rewardDice[selectedDieIndex].num_faces():
		#var newFaceUIInstance = dieFaceUIScene.instantiate() as DieFaceUI
		#var faceIndexNode = newFaceUIInstance.find_child("FaceIndex") as RichTextLabel
		#faceIndexNode.text = str(faceIndex)
		#var typeNode = newFaceUIInstance.find_child("Type") as RichTextLabel
		#typeNode.text = str(DieFaceData.FaceType.keys()[rewardDice[selectedDieIndex].faces[faceIndex].type])
		#var valueNode = newFaceUIInstance.find_child("Value") as RichTextLabel
		#valueNode.text = str(rewardDice[selectedDieIndex].faces[faceIndex].value)
		#faceGrid.add_child(newFaceUIInstance)

#func clear_die_face_grid():
	#for child in get_node('DieFaceGrid').get_children():
		#get_node('DieFaceGrid').remove_child(child)


func _on_roll_pressed():
	print("Rolling reward dice")
	
	PlayerDice.RewardStakes = []
	for die in PlayerDice.RewardDice:
		var rolledIndex = die.roll()
		PlayerDice.RewardStakes.append(die.faces[rolledIndex])
		var newFaceUIInstance = dieFaceUIScene.instantiate()# as DieFaceUI
		var typeNode = newFaceUIInstance.find_child("FaceTypeValue") as Label
		typeNode.text = str(DieFaceData.FaceType.keys()[die.faces[rolledIndex].type])
		var faceIndexNode = newFaceUIInstance.find_child("FaceIndexValue") as Label
		faceIndexNode.text = str(rolledIndex)
		var valueNode = newFaceUIInstance.find_child("FaceValueValue") as Label
		valueNode.text = str(DieFaceData.RewardTypeValue.keys()[die.faces[rolledIndex].value])
		resultGrid.add_child(newFaceUIInstance)
	
	$Roll.visible = false
	$Continue.visible = true
	$ResultStakesText.visible = true
	$DiceGrid.visible = false
	$DiceGridLabel.visible = false


func _on_continue_pressed():
	get_tree().change_scene_to_file("res://scenes/RollScore.tscn")
